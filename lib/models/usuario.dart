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
    required this.createdAt,
    required this.updatedAt,
  });

  factory Usuario.firebase({
    required String uid,
    required String nombre,
    required String email,
    Rol rol = Rol.usuario,
  }) {
    final ahora = DateTime.now();
    return Usuario(
      uid: uid,
      nombre: nombre,
      email: email,
      rol: rol
    );
  }

}