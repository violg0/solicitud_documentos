import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/usuario.dart' show Usuario;

class UsuarioService {
  static const Duration _tiempoMaximo = Duration(seconds: 10);

  CollectionReference<Map<String, dynamic>> get _coleccion =>
      FirebaseFirestore.instance.collection('Usuarios');

  Future<List<Usuario>> listar() async {
    final snapshot = await _coleccion.orderBy('id').get();
    return snapshot.docs.map((d) => Usuario.fromJson(d.data())).toList();
  }

  Future<Usuario?> obtenerPorId(int id) async {
    final doc = await _coleccion.doc(id.toString()).get();
    final data = doc.data();
    return data == null ? null : Usuario.fromJson(data);
  }

  Future<void> guardar(Usuario Usuario) async {
    await _coleccion
        .doc(Usuario.uid.toString())
        .set(Usuario.toJson())
        .timeout(_tiempoMaximo);
  }

  Future<void> eliminar(int id) {
    return _coleccion.doc(id.toString()).delete();
  }
}
