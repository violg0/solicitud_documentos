class Documento {
  final String id;
  final String nombre;
  final String descripcion;
  final String imagen;
  final bool habilitado;

  Documento({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.imagen,
    required this.habilitado,
  });

  factory Documento.fromJson(Map<String, dynamic> json) {
    return Documento(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      imagen: json['imagen'],
      habilitado: json['habilitado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'imagen': imagen,
      'habilitado': habilitado,
    };
  }
}
