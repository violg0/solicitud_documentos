import 'rol.dart';

class Usuario {
  final String uid;
  final String nombre;
  final String email;
  final Rol rol;

  const Usuario({
    required this.uid,
    required this.nombre,
    required this.email,
    required this.rol,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      uid: json['uid'],
      nombre: json['nombre'],
      email: json['email'],
      rol: Rol.values.byName(json['rol']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'uid': uid, 'nombre': nombre, 'email': email, 'rol': rol.name};
  }
}
