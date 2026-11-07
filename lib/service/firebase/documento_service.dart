import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/documento.dart';
import 'crash_service.dart';

class DocumentoService {
  const DocumentoService({required CrashService crashService})
    : _crashService = crashService;

  final CrashService _crashService;

  CollectionReference<Map<String, dynamic>> get _coleccion =>
      FirebaseFirestore.instance.collection('Documentos');

  Future<List<Documento>> listar() => _crashService.registrar(() async {
    final snapshot = await _coleccion.get();
    return snapshot.docs
        .map((d) => Documento.fromJson({...d.data(), 'id': d.id}))
        .toList();
  }, 'DocumentoService.listar');

  Future<Documento?> obtenerPorId(String id) => _crashService.registrar(
    () async {
      final doc = await _coleccion.doc(id).get();
      final data = doc.data();
      return data == null ? null : Documento.fromJson({...data, 'id': doc.id});
    },
    'DocumentoService.obtenerPorId',
  );
}
