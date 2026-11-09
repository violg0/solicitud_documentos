import 'estados.dart';

class Solicitud {
  final String id;
  final String idDocumento;
  final String idUsuario;
  final String periodo;
  final String observacionEstudiante;
  final EstadoSolicitud estado;
  final DateTime fechaCreacion;
  final DateTime fechaModificacion;
  final String? observacionRevision;
  final DateTime? fechaEntrega;
  final String? entregadoPor;

  Solicitud({
    required this.id,
    required this.idDocumento,
    required this.idUsuario,
    required this.periodo,
    this.observacionEstudiante = '',
    required this.estado,
    DateTime? fechaCreacion,
    required this.fechaModificacion,
    this.observacionRevision,
    this.fechaEntrega,
    this.entregadoPor,
  }) : fechaCreacion = fechaCreacion ?? fechaModificacion;

  factory Solicitud.fromJson(Map<String, dynamic> json) {
    return Solicitud(
      id: json['id'],
      idDocumento: json['idDocumento'],
      idUsuario: json['idUsuario'],
      periodo: json['periodo'],
      observacionEstudiante: json['observacionEstudiante'] ?? '',
      estado: EstadoSolicitud.values.byName(json['estado']),
      fechaCreacion: DateTime.parse(
        json['fechaCreacion'] ?? json['fechaModificacion'],
      ).toUtc(),
      fechaModificacion: DateTime.parse(json['fechaModificacion']).toUtc(),
      observacionRevision: json['observacionRevision'],
      fechaEntrega: json['fechaEntrega'] == null
          ? null
          : DateTime.parse(json['fechaEntrega']).toUtc(),
      entregadoPor: json['entregadoPor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idDocumento': idDocumento,
      'idUsuario': idUsuario,
      'periodo': periodo,
      'observacionEstudiante': observacionEstudiante,
      'estado': estado.name,
      // Siempre en UTC: toIso8601String() de un DateTime UTC termina en "Z".
      'fechaCreacion': fechaCreacion.toUtc().toIso8601String(),
      'fechaModificacion': fechaModificacion.toUtc().toIso8601String(),
      'observacionRevision': observacionRevision,
      'fechaEntrega': fechaEntrega?.toUtc().toIso8601String(),
      'entregadoPor': entregadoPor,
    };
  }
}