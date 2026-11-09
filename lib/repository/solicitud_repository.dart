import 'dart:async';

import '../local/solicitud_local_data_source.dart';
import '../validators/solicitud_validators.dart';
import 'documento_repository.dart';
import '../models/documento.dart';
import '../models/estados.dart';
import '../models/solicitud.dart';
import '../models/usuario.dart';
import '../service/firebase/solicitud_service.dart';

class SolicitudRepository {
  final SolicitudLocalDataSource local;
  final SolicitudService remote;
  final DocumentoRepository documentoRepository;
  final Duration syncTimeout;
  Future<void>? _syncInProgress;

  SolicitudRepository({
    required this.local,
    required this.remote,
    required this.documentoRepository,
    this.syncTimeout = const Duration(seconds: 10),
  });

  /// Intenta traer de Firestore y refrescar el caché local.
  /// Si falla (sin conexión), devuelve lo último guardado localmente.
  /// Si [idUsuario] no es null, solo devuelve las solicitudes de ese usuario.
  Future<List<Solicitud>> obtenerSolicitudes({
    required String? idUsuario,
  }) async {
    try {
      final solicitudes = await remote.listar(idUsuario: idUsuario);
      final locales = {
        for (final solicitud in await local.getSolicitudes(
          idUsuario: idUsuario,
        ))
          solicitud.id: solicitud,
      };
      final reconciliadas = <Solicitud>[];
      for (final s in solicitudes) {
        final local = locales[s.id];
        // Ambas fechas son instantes en UTC (los modelos las normalizan con
        // toUtc() al leer), así que la comparación no depende de la zona.
        if (local == null ||
            !local.fechaModificacion.toUtc().isAfter(
              s.fechaModificacion.toUtc(), //¿mi copia local NO es más nueva que la de Firestore
            )) {
          await this.local.saveSolicitud(s);
          await this.local.markSynced(s.id);
          reconciliadas.add(s);
        } else {
          reconciliadas.add(local);
        }
      }
      final remotas = {for (final solicitud in solicitudes) solicitud.id};
      reconciliadas.addAll(
        locales.values.where(
          (solicitud) =>
              !remotas.contains(solicitud.id) &&
              (idUsuario == null || solicitud.idUsuario == idUsuario),
        ),
      );
      return reconciliadas;
    } catch (_) {
      return local.getSolicitudes(idUsuario: idUsuario);
    }
  }

  /// Ids de las solicitudes que siguen pendientes de subir a Firestore
  /// (`pendingSync = true` en Drift).
  Future<Set<String>> idsPendientes({required String? idUsuario}) =>
      local.getIdsPendientes(idUsuario: idUsuario);

  Future<void> crearSolicitud(Solicitud solicitud, Documento documento) async {
    final error =
        SolicitudValidators.validarHabilitado(documento.habilitado) ??
        SolicitudValidators.validarPeriodo(solicitud.periodo);
    if (error != null) {
      throw Exception(error);
    }
    await local.saveSolicitud(solicitud);
    // Firestore puede esperar indefinidamente sin red. La UI confirma SQLite.
    unawaited(_syncAfterSave(solicitud.idUsuario));
  }

  Future<void> _syncAfterSave(String idUsuario) async {
    try {
      final active = _syncInProgress;
      if (active != null) await active;
      await syncPending(idUsuario: idUsuario);
    } catch (_) {
      // El guardado local ya terminó; se puede reintentar después.
    }
  }

  /// Sube las pendientes de [idUsuario] (de todas las cuentas si es null).
  Future<void> syncPending({String? idUsuario}) {
    return _syncInProgress ??= _syncPending(idUsuario).whenComplete(() {
      _syncInProgress = null;
    });
  }

  Future<void> _syncPending(String? idUsuario) async {
    final pending = await local.getPendingSolicitudes(idUsuario: idUsuario);
    for (final solicitud in pending) {
      try {
        final documento = await documentoRepository.obtenerPorId(
          solicitud.idDocumento,
        );
        if (documento == null) continue;
        await remote.guardar(solicitud, documento).timeout(syncTimeout);
        await local.markSynced(solicitud.id);
      } catch (_) {
        // Se conserva pendingSync hasta recibir una confirmación remota.
      }
    }
  }

  /// [observacion] es el mensaje de quien cambia el estado: si el revisor
  /// aprueba o rechaza, queda como `observacionRevision`. Devuelve la
  /// solicitud ya actualizada (la misma que queda en Firestore y en Drift).
  Future<Solicitud> cambiarEstado(
    Solicitud solicitud,
    EstadoSolicitud nuevo,
    Usuario usuario, {
    String? observacion,
  }) async {
    // Una sola hora, en UTC, para Firestore y para la copia local.
    final ahora = DateTime.now().toUtc();
    // El servicio escribe en Firestore y devuelve la solicitud tal como quedó.
    final actualizada = await remote.cambiarEstado(
      solicitud,
      nuevo,
      usuario,
      observacion: observacion,
      fecha: ahora,
    );
    await local.saveSolicitud(actualizada);
    await local.markSynced(actualizada.id);
    return actualizada;
  }
}
