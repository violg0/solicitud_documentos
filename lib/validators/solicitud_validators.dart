import '../models/estados.dart';
import '../models/periodos_academicos.dart';
import '../models/rol.dart';
import '../models/solicitud.dart';
import '../models/usuario.dart';

class SolicitudValidators {
  static const Map<EstadoSolicitud, Map<EstadoSolicitud, Rol>>
  _transicionesPermitidas = {
    EstadoSolicitud.solicitada: {
      EstadoSolicitud.cancelada: Rol.estudiante,
      EstadoSolicitud.enRevision: Rol.revisor,
    },
    EstadoSolicitud.enRevision: {
      EstadoSolicitud.aprobada: Rol.revisor,
      EstadoSolicitud.rechazada: Rol.revisor,
    },
    EstadoSolicitud.aprobada: {EstadoSolicitud.entregada: Rol.secretaria},
  };

  static String? validarHabilitado(bool habilitado) {
    if (!habilitado) {
      return 'Este tipo de documento no está disponible para solicitar';
    }
    return null;
  }

  static String? validarPeriodo(String? periodo) {
    if (periodo == null || !periodosAcademicos.contains(periodo)) {
      return 'Seleccionar un período académico válido (2025-1 a 2026-2)';
    }
    return null;
  }

  static String? validarCambioEstado(
    Solicitud solicitud,
    EstadoSolicitud nuevo,
    Usuario usuario,
  ) {
    final rolPermitido = _transicionesPermitidas[solicitud.estado]?[nuevo];
    if (rolPermitido == null || rolPermitido != usuario.rol) {
      return 'El cambio de estado no está permitido';
    }

    if (usuario.rol == Rol.estudiante && solicitud.idUsuario != usuario.uid) {
      return 'El estudiante solo puede modificar sus propias solicitudes';
    }

    return null;
  }
}
