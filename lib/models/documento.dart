class Documento {
  final String id;
  final String nombre;
  final String descripcion;
  final bool habilitado;

  Documento({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.habilitado,
  });

  factory Documento.fromJson(Map<String, dynamic> json) {
    return Documento(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      habilitado: json['habilitado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'habilitado': habilitado,
    };
  }
}
