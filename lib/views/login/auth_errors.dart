import 'package:firebase_auth/firebase_auth.dart';

const String mensajeErrorGenerico =
    'Sin conexión o error inesperado. Intenta de nuevo';

/// Traduce el código de un [FirebaseAuthException] a un mensaje para el
/// usuario. Cualquier código no contemplado cae en [mensajeErrorGenerico].
String mensajeErrorAuth(FirebaseAuthException e) {
  switch (e.code) {
    case 'invalid-email':
      return 'El correo no tiene un formato válido';
    case 'user-not-found':
      return 'No existe una cuenta con este correo';
    case 'wrong-password':
      return 'La contraseña es incorrecta';
    // Con la protección contra enumeración de correos (activa por defecto en
    // proyectos nuevos) Firebase ya no distingue usuario/contraseña y
    // devuelve este código en lugar de user-not-found / wrong-password.
    case 'invalid-credential':
      return 'Correo o contraseña incorrectos';
    case 'email-already-in-use':
      return 'Ya existe una cuenta con este correo';
    default:
      return mensajeErrorGenerico;
  }
}
