import '../local/motivo_local_data_source.dart';
import '../models/motivo.dart';
import '../service/firebase/motivo_service.dart';

class MotivoRepository {
  final MotivoLocalDataSource local;
  final MotivoService remote;

  MotivoRepository({required this.local, required this.remote});

  Future<List<Motivo>> obtenerPorSolicitud(String idSolicitud) async {
    try {
      final motivos = await remote.listarPorSolicitud(idSolicitud); //intenta remoto
      for (final m in motivos) {
        await local.saveMotivo(m); //actualiza el caché local
      }
      return motivos; 
    } catch (_) {
      return local.getMotivosPorSolicitud(idSolicitud); //sin internet, usa lo local
    }
  }

  Future<void> crear(Motivo motivo) async {
    // Con id vacío cada motivo nuevo pisaría al anterior en la base local.
    assert(motivo.id.isNotEmpty, 'El motivo necesita un id (UUID) único');
    await local.saveMotivo(motivo); //guarda local primero
    try {
      await remote.guardar(motivo); //intenta subir a Firestore
    } catch (_) {
      //si falla, se queda pendiente en local (pendingSync = true)
    }
  }
}