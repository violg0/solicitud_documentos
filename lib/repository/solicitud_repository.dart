import '../local/solicitud_local_data_source.dart';
import '../models/documento.dart';
import '../models/estados.dart';
import '../models/solicitud.dart';
import '../models/usuario.dart';
import '../service/firebase/solicitud_service.dart';

class SolicitudRepository {
  final SolicitudLocalDataSource local;
  final SolicitudService remote;

  SolicitudRepository({required this.local, required this.remote});

  /// Intenta traer de Firestore y refrescar el caché local.
  /// Si falla (sin conexión), devuelve lo último guardado localmente.
  Future<List<Solicitud>> obtenerSolicitudes() async {
    try {
      final solicitudes = await remote.listar();
      for (final s in solicitudes) {
        await local.saveSolicitud(s);
        await local.markSynced(s.id);
      }
      return solicitudes;
    } catch (_) {
      return local.getSolicitudes();
    }
  }

  Future<String> crearSolicitud(Solicitud solicitud, Documento documento) async {
    final id = await remote.guardar(solicitud, documento);
    return id;
  }

  Future<void> cambiarEstado(
    Solicitud solicitud,
    EstadoSolicitud nuevo,
    Usuario usuario,
  ) {
    return remote.cambiarEstado(solicitud, nuevo, usuario);
  }
}