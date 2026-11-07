import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/solicitud.dart' show Solicitud;

class SolicitudService {
  static const Duration _tiempoMaximo = Duration(seconds: 10);

  CollectionReference<Map<String, dynamic>> get _coleccion =>
      FirebaseFirestore.instance.collection('Solicituds');

  Future<List<Solicitud>> listar() async {
    final snapshot = await _coleccion.orderBy('id').get();
    return snapshot.docs.map((d) => Solicitud.fromJson(d.data())).toList();
  }

  Future<Solicitud?> obtenerPorId(int id) async {
    final doc = await _coleccion.doc(id.toString()).get();
    final data = doc.data();
    return data == null ? null : Solicitud.fromJson(data);
  }

  Future<String> guardar(Solicitud solicitud) async {
    final docRef = _coleccion.doc(); // Firestore genera el ID

    await docRef.set(solicitud.toJson()..remove('id')).timeout(_tiempoMaximo);

    return docRef.id;
  }

  Future<void> eliminar(int id) {
    return _coleccion.doc(id.toString()).delete();
  }
}
