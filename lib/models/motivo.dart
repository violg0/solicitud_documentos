import 'estados.dart';

class Motivo {
  final String id;
  final String idSolicitud;
  final String mensaje;
  final EstadoSolicitud estado;
  final DateTime fechaCreacion;

  Motivo({
    required this.id,
    required this.idSolicitud,
    required this.mensaje,
    required this.estado,
    required this.fechaCreacion,
  });

  factory Motivo.fromJson(Map<String, dynamic> json) {
    return Motivo(
      id: json['id'],
      idSolicitud: json['idSolicitud'],
      mensaje: json['mensaje'],
      estado: json['estado'],
      fechaCreacion: DateTime.parse(json['fechaCreacion']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idSolicitud': idSolicitud,
      'mensaje': mensaje,
      'estado': estado,
      'fechaCreacion': fechaCreacion.toIso8601String(),
    };
  }
}
