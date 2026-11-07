import 'package:firebase_auth/firebase_auth.dart';
import 'package:solicitud_documentos/models/rol.dart';
import 'package:solicitud_documentos/models/usuario.dart';
import 'package:solicitud_documentos/service/firebase/usuario_service.dart';

abstract class AuthService {
  Stream<User?> authStateChanges();
  Future<void> login({required String email, required String password});
  Future<void> register({
    required String nombre,
    required String email,
    required String password,
    required Rol rol,
  });
  Future<void> logout();
}

class FirebaseAuthService implements AuthService {
  FirebaseAuthService(this._usuarioService, {FirebaseAuth? firebaseAuth})
    : _auth = firebaseAuth ?? FirebaseAuth.instance;

  final UsuarioService _usuarioService;
  final FirebaseAuth _auth;

  @override
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  @override
  Future<void> login({required String email, required String password}) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  @override
  Future<void> register({
    required String nombre,
    required String email,
    required String password,
    required Rol rol,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = cred.user!;
    try {
      await _usuarioService.guardar(
        Usuario(
          uid: user.uid,
          nombre: nombre.trim(),
          email: email.trim(),
          rol: rol,
        ),
      );
    } catch (_) {
      await user.delete(); // sin perfil no dejamos la cuenta
      rethrow;
    }
  }

  @override
  Future<void> logout() => _auth.signOut();
}
