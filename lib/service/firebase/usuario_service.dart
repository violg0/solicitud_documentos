import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/usuario.dart' show Usuario;

class UsuarioService {
  static const Duration _tiempoMaximo = Duration(seconds: 10);

  CollectionReference<Map<String, dynamic>> get _coleccion =>
      FirebaseFirestore.instance.collection('Usuarios');

  Future<List<Usuario>> listar() async {
    final snapshot = await _coleccion.get();
    return snapshot.docs
        .map((d) => Usuario.fromJson({...d.data(), 'uid': d.id}))
        .toList();
  }

  Future<Usuario?> obtenerPorId(String id) async {
    final doc = await _coleccion.doc(id).get();
    final data = doc.data();
    return data == null ? null : Usuario.fromJson({...data, 'uid': doc.id});
  }

  Future<void> guardar(Usuario usuario) async {
    await _coleccion
        .doc(usuario.uid)
        .set(usuario.toJson()..remove('uid'))
        .timeout(_tiempoMaximo);
  }

  Future<void> eliminar(String id) {
    return _coleccion.doc(id).delete();
  }
}
