import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/usuario.dart' show Usuario;
import 'crash_service.dart';

class UsuarioService {
  static const Duration _tiempoMaximo = Duration(seconds: 10);

  const UsuarioService({required CrashService crashService})
    : _crashService = crashService;

  final CrashService _crashService;

  CollectionReference<Map<String, dynamic>> get _coleccion =>
      FirebaseFirestore.instance.collection('Usuarios');

  Future<List<Usuario>> listar() => _crashService.registrar(() async {
    final snapshot = await _coleccion.get();
    return snapshot.docs
        .map((d) => Usuario.fromJson({...d.data(), 'uid': d.id}))
        .toList();
  }, 'UsuarioService.listar');

  Stream<Usuario?> observar(String uid) => _coleccion
      .doc(uid)
      .snapshots()
      .map(
        (doc) => doc.data() == null
            ? null
            : Usuario.fromJson({...doc.data()!, 'uid': doc.id}),
      );

  Future<Usuario?> obtenerPorId(String id) => _crashService.registrar(() async {
    final doc = await _coleccion.doc(id).get();
    final data = doc.data();
    return data == null ? null : Usuario.fromJson({...data, 'uid': doc.id});
  }, 'UsuarioService.obtenerPorId');

  Future<void> guardar(Usuario usuario) => _crashService.registrar(
    () => _coleccion
        .doc(usuario.uid)
        .set(usuario.toJson()..remove('uid'))
        .timeout(_tiempoMaximo),
    'UsuarioService.guardar',
  );

  Future<void> eliminar(String id) => _crashService.registrar(
    () => _coleccion.doc(id).delete().timeout(_tiempoMaximo),
    'UsuarioService.eliminar',
  );
}
