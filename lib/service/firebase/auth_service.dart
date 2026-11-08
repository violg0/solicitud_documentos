import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:solicitud_documentos/models/rol.dart';
import 'package:solicitud_documentos/models/usuario.dart';
import 'package:solicitud_documentos/service/firebase/usuario_service.dart';

abstract class AuthService {
  Stream<AppAuthUser?> authStateChanges();
  Future<void> login({required String email, required String password});
  Future<void> register({
    required String nombre,
    required String email,
    required String password,
    required Rol rol,
  });
  Future<void> logout();
  Future<Usuario?> obtenerPerfil(String uid);
}

class AppAuthUser {
  const AppAuthUser({required this.uid, required this.email});

  final String uid;
  final String email;
}

class FirebaseAuthService implements AuthService {
  FirebaseAuthService(this._usuarioService, {FirebaseAuth? firebaseAuth})
    : _auth = firebaseAuth ?? FirebaseAuth.instance;

  final UsuarioService _usuarioService;
  final FirebaseAuth _auth;

  @override
  Stream<AppAuthUser?> authStateChanges() => _auth.authStateChanges().map(
    (user) => user == null
        ? null
        : AppAuthUser(uid: user.uid, email: user.email ?? ''),
  );

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

  @override
  Future<Usuario?> obtenerPerfil(String uid) => _usuarioService.obtenerPorId(uid);
}

/// Keeps authentication and profiles backed by Firebase.
class HybridAuthService implements AuthService {
  HybridAuthService({this._firebase}) {
    _firebaseSubscription = _firebase?.authStateChanges().listen((user) {
      _firebaseUser = user;
      _controller.add(user);
    });
  }

  final FirebaseAuthService? _firebase;
  final _controller = StreamController<AppAuthUser?>.broadcast();
  StreamSubscription<AppAuthUser?>? _firebaseSubscription;
  AppAuthUser? _firebaseUser;

  @override
  Stream<AppAuthUser?> authStateChanges() async* {
    yield _firebaseUser;
    yield* _controller.stream;
  }

  @override
  Future<void> login({required String email, required String password}) async {
    final firebase = _firebase;
    if (firebase == null) {
      throw FirebaseAuthException(
        code: 'operation-not-allowed',
        message: 'Firebase no está configurado',
      );
    }
    await firebase.login(email: email, password: password);
  }

  @override
  Future<void> register({
    required String nombre,
    required String email,
    required String password,
    required Rol rol,
  }) {
    final firebase = _firebase;
    if (firebase == null) {
      throw FirebaseAuthException(
        code: 'operation-not-allowed',
        message: 'Firebase no está configurado',
      );
    }
    return firebase.register(
      nombre: nombre,
      email: email,
      password: password,
      rol: rol,
    );
  }

  @override
  Future<void> logout() async {
    _controller.add(null);
    await _firebase?.logout();
  }

  @override
  Future<Usuario?> obtenerPerfil(String uid) async {
    final firebase = _firebase;
    return firebase?.obtenerPerfil(uid);
  }

  void dispose() {
    _firebaseSubscription?.cancel();
    _controller.close();
  }
}
