import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/motivo.dart' show Motivo;

class MotivoService {
  static const Duration _tiempoMaximo = Duration(seconds: 10);

  CollectionReference<Map<String, dynamic>> get _coleccion =>
      FirebaseFirestore.instance.collection('Motivos');

  Future<List<Motivo>> listar() async {
    final snapshot = await _coleccion.get();
    return snapshot.docs
        .map((d) => Motivo.fromJson({...d.data(), 'id': d.id}))
        .toList();
  }

  Future<List<Motivo>> listarPorSolicitud(String idSolicitud) async {
    final snapshot = await _coleccion
        .where('idSolicitud', isEqualTo: idSolicitud)
        .get();
    return snapshot.docs
        .map((d) => Motivo.fromJson({...d.data(), 'id': d.id}))
        .toList();
  }

  Future<Motivo?> obtenerPorId(String id) async {
    final doc = await _coleccion.doc(id).get();
    final data = doc.data();
    return data == null ? null : Motivo.fromJson({...data, 'id': doc.id});
  }

  Future<String> guardar(Motivo motivo) async {
    final docRef = _coleccion.doc(); // Firestore genera el ID
    await docRef.set(motivo.toJson()..remove('id')).timeout(_tiempoMaximo);
    return docRef.id;
  }

  Future<void> eliminar(String id) {
    return _coleccion.doc(id).delete();
  }
}
