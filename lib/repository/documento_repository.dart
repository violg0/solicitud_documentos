import '../local/documento_local_data_source.dart';
import '../models/documento.dart';
import '../service/api/documento_service.dart';

class DocumentoRepository {
  final DocumentoLocalDataSource local;
  final DocumentoService remote;

  DocumentoRepository({required this.local, required this.remote});

  Future<List<Documento>> obtenerTodos() async {
    try {
      final documentos = await remote.getDocumentos(); 
      for (final d in documentos) {
        await local.saveDocumento(d);
      }
      return documentos; 
    } catch (_) {
      final cacheados = await local.getDocumentos();
      // Sin red y sin caché no es "catálogo vacío": es un error que la
      // pantalla debe mostrar con su botón de reintentar.
      if (cacheados.isEmpty) rethrow;
      return cacheados;
    }
  }

    Future<Documento?> obtenerPorId(String id) async {
    Documento? encontrado;
    try {
      final documentos = await remote.getDocumentos(); 
      for (final d in documentos) {
        if(d.id == id){
          await local.saveDocumento(d);
          encontrado = d;
        }
      }
      return encontrado;
    } catch (_) {
      return local.getDocumentoPorId(id); 
    }
  }


}