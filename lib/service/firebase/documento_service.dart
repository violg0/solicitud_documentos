import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/documento.dart';

class DocumentoService {
  CollectionReference<Map<String, dynamic>> get _coleccion =>
      FirebaseFirestore.instance.collection('Documentos');

  Future<List<Documento>> listar() async {
    final snapshot = await _coleccion.get();
    return snapshot.docs
        .map((d) => Documento.fromJson({...d.data(), 'id': d.id}))
        .toList();
  }

  Future<Documento?> obtenerPorId(String id) async {
    final doc = await _coleccion.doc(id).get();
    final data = doc.data();
    return data == null ? null : Documento.fromJson({...data, 'id': doc.id});
  }
}
