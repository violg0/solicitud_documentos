class Solicitud{
  final String id;
  final String idDocumento;
  final String idUsuario;
  final EstadoSolicitud estado;

  Solicitud (
    {
      required this.id,
      required this.idDocumento,
      required this.idUsuario,
      required this.estado
    }
  );
  
  factory Solicitud.fromJson(Map<String,dynamic> json) {
    return Solicitud(
    id: json['id'],
    idDocumento: json['idDocumento'],
    idUsuario: json['idUsuario'],
    estado: json['estado'], 

    );
  }

}