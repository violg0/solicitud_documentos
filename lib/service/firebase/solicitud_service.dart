import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/documento.dart';
import '../../models/estados.dart';
import '../../models/solicitud.dart' show Solicitud;
import '../../models/usuario.dart';
import '../../validators/solicitud_validators.dart';

class SolicitudService {
  static const Duration _tiempoMaximo = Duration(seconds: 10);

  CollectionReference<Map<String, dynamic>> get _coleccion =>
      FirebaseFirestore.instance.collection('Solicitudes');

  Future<List<Solicitud>> listar() async {
    final snapshot = await _coleccion.get();
    return snapshot.docs
        .map((d) => Solicitud.fromJson({...d.data(), 'id': d.id}))
        .toList();
  }

  Future<Solicitud?> obtenerPorId(String id) async {
    final doc = await _coleccion.doc(id).get();
    final data = doc.data();
    return data == null ? null : Solicitud.fromJson({...data, 'id': doc.id});
  }

  Future<String> guardar(Solicitud solicitud, Documento documento) async {
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

    final docRef = _coleccion.doc(); // Firestore genera el ID

    await docRef.set(solicitud.toJson()..remove('id')).timeout(_tiempoMaximo);

    return docRef.id;
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

    await _coleccion
        .doc(solicitud.id)
        .update({'estado': nuevo.name})
        .timeout(_tiempoMaximo);
  }

  Future<void> eliminar(String id) {
    return _coleccion.doc(id).delete();
  }
}
