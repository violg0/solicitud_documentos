import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/documento.dart';
import '../../models/estados.dart';
import '../../models/solicitud.dart' show Solicitud;
import '../../models/usuario.dart';
import '../../validators/solicitud_validators.dart';
import 'crash_service.dart';

class SolicitudService {
  static const Duration _tiempoMaximo = Duration(seconds: 10);

  const SolicitudService({required CrashService crashService})
    : _crashService = crashService;

  final CrashService _crashService;

  CollectionReference<Map<String, dynamic>> get _coleccion =>
      FirebaseFirestore.instance.collection('Solicitudes');

  /// Si [idUsuario] no es null, la consulta se filtra en el servidor: las
  /// reglas de Firestore solo dejan a un estudiante leer sus propias
  /// solicitudes, así que pedir toda la colección sería rechazado.
  Future<List<Solicitud>> listar({String? idUsuario}) =>
      _crashService.registrar(() async {
        final Query<Map<String, dynamic>> consulta = idUsuario == null
            ? _coleccion
            : _coleccion.where('idUsuario', isEqualTo: idUsuario);
        final snapshot = await consulta.get();
        return snapshot.docs
            .map((d) => Solicitud.fromJson({...d.data(), 'id': d.id}))
            .toList();
      }, 'SolicitudService.listar');

  Future<Solicitud?> obtenerPorId(String id) => _crashService.registrar(
    () async {
      final doc = await _coleccion.doc(id).get();
      final data = doc.data();
      return data == null ? null : Solicitud.fromJson({...data, 'id': doc.id});
    },
    'SolicitudService.obtenerPorId',
  );

  Future<void> guardar(Solicitud solicitud, Documento documento) async {
    final errorHabilitado = SolicitudValidators.validarHabilitado(
      documento.habilitado,
    );
    if (errorHabilitado != null) {
      throw Exception(errorHabilitado);
    }

    final errorPeriodo = SolicitudValidators.validarPeriodo(solicitud.periodo);
    if (errorPeriodo != null) {
      throw Exception(errorPeriodo);
    }

    return _crashService.registrar(() async {
      final docRef = _coleccion.doc(solicitud.id); // id generado en el cliente
      await docRef.set(solicitud.toJson()..remove('id')).timeout(_tiempoMaximo);
    }, 'SolicitudService.guardar');
  }

  Future<void> cambiarEstado(
    Solicitud solicitud,
    EstadoSolicitud nuevo,
    Usuario usuario,
  ) async {
    final error = SolicitudValidators.validarCambioEstado(
      solicitud,
      nuevo,
      usuario,
    );
    if (error != null) {
      throw Exception(error);
    }

    await _crashService.registrar(
      () => _coleccion
          .doc(solicitud.id)
          .update({
            'estado': nuevo.name,
            'fechaModificacion': DateTime.now().toIso8601String(),
          })
          .timeout(_tiempoMaximo),
      'SolicitudService.cambiarEstado',
    );
  }

  Future<void> eliminar(String id) => _crashService.registrar(
    () => _coleccion.doc(id).delete().timeout(_tiempoMaximo),
    'SolicitudService.eliminar',
  );
}
