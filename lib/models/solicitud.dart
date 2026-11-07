import 'estados.dart';

class Solicitud {
  final String id;
  final String idDocumento;
  final String idUsuario;
  final String periodo;
  final EstadoSolicitud estado;

  Solicitud({
    required this.id,
    required this.idDocumento,
    required this.idUsuario,
    required this.periodo,
    required this.estado,
  });

  factory Solicitud.fromJson(Map<String, dynamic> json) {
    return Solicitud(
      id: json['id'],
      idDocumento: json['idDocumento'],
      idUsuario: json['idUsuario'],
      periodo: json['periodo'],
      estado: EstadoSolicitud.values.byName(json['estado']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idDocumento': idDocumento,
      'idUsuario': idUsuario,
      'periodo': periodo,
      'estado': estado.name,
    };
  }
}
