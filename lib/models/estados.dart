enum EstadoSolicitud {
  solicitada,
  enRevision,
  aprobada,
  rechazada,
  entregada,
  cancelada,
}

/// Texto legible para mostrar en pantalla. Lo que se guarda en Firestore y en
/// Drift sigue siendo `name` (el nombre crudo del enum).
extension EstadoSolicitudLabel on EstadoSolicitud {
  String get etiqueta => switch (this) {
    EstadoSolicitud.solicitada => 'Solicitada',
    EstadoSolicitud.enRevision => 'En revisión',
    EstadoSolicitud.aprobada => 'Aprobada',
    EstadoSolicitud.rechazada => 'Rechazada',
    EstadoSolicitud.entregada => 'Entregada',
    EstadoSolicitud.cancelada => 'Cancelada',
  };
}
