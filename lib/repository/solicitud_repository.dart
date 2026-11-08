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
      for (final s in solicitudes) {
        await local.saveSolicitud(s);
        await local.markSynced(s.id);
      }
      return solicitudes;
    } catch (_) {
      return (await local.getSolicitudes())
          .where((s) => idUsuario == null || s.idUsuario == idUsuario)
          .toList();
    }
  }

  Future<void> crearSolicitud(Solicitud solicitud, Documento documento) async {
    final error =
        SolicitudValidators.validarHabilitado(documento.habilitado) ??
        SolicitudValidators.validarPeriodo(solicitud.periodo);
    if (error != null) {
      throw Exception(error);
    }
    await local.saveSolicitud(solicitud);
    // Firestore puede esperar indefinidamente sin red. La UI confirma SQLite.
    unawaited(_syncAfterSave());
  }

  Future<void> _syncAfterSave() async {
    try {
      final active = _syncInProgress;
      if (active != null) await active;
      await syncPending();
    } catch (_) {
      // El guardado local ya terminó; se puede reintentar después.
    }
  }

  Future<void> syncPending() {
    return _syncInProgress ??= _syncPending().whenComplete(() {
      _syncInProgress = null;
    });
  }

  Future<void> _syncPending() async {
    final pending = await local.getPendingSolicitudes();
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

  Future<void> cambiarEstado(
    Solicitud solicitud,
    EstadoSolicitud nuevo,
    Usuario usuario,
  ) {
    return remote.cambiarEstado(solicitud, nuevo, usuario);
  }
}
