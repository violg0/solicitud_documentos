import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/motivo.dart' show Motivo;

class MotivoService {
  static const Duration _tiempoMaximo = Duration(seconds: 10);

  CollectionReference<Map<String, dynamic>> get _coleccion =>
      FirebaseFirestore.instance.collection('Motivos');

  Future<List<Motivo>> listar() async {
    final snapshot = await _coleccion.orderBy('id').get();
    return snapshot.docs.map((d) => Motivo.fromJson(d.data())).toList();
  }

  Future<List<Motivo>> listarPorSolicitud(int idSolicitud) async {
    final snapshot = await _coleccion
        .where('id_solicitud', isEqualTo: idSolicitud)
        .get();
    return snapshot.docs.map((d) => Motivo.fromJson(d.data())).toList();
  }

  Future<Motivo?> obtenerPorId(int id) async {
    final doc = await _coleccion.doc(id.toString()).get();
    final data = doc.data();
    return data == null ? null : Motivo.fromJson(data);
  }

  Future<String> guardar(Motivo solicitud) async {
    final docRef = _coleccion.doc(); // Firestore genera el ID
    await docRef.set(solicitud.toJson()..remove('id')).timeout(_tiempoMaximo);
    return docRef.id;
  }

  Future<void> eliminar(int id) {
    return _coleccion.doc(id.toString()).delete();
  }
}
