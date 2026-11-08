import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/motivo.dart' show Motivo;
import 'crash_service.dart';

class MotivoService {
  static const Duration _tiempoMaximo = Duration(seconds: 10);

  const MotivoService({required this._crashService});

  final CrashService _crashService;

  CollectionReference<Map<String, dynamic>> get _coleccion =>
      FirebaseFirestore.instance.collection('Motivos');

  Future<List<Motivo>> listar() => _crashService.registrar(() async {
    final snapshot = await _coleccion.get();
    return snapshot.docs
        .map((d) => Motivo.fromJson({...d.data(), 'id': d.id}))
        .toList();
  }, 'MotivoService.listar');

  Future<List<Motivo>> listarPorSolicitud(String idSolicitud) =>
      _crashService.registrar(() async {
        final snapshot = await _coleccion
            .where('idSolicitud', isEqualTo: idSolicitud)
            .get();
        return snapshot.docs
            .map((d) => Motivo.fromJson({...d.data(), 'id': d.id}))
            .toList();
      }, 'MotivoService.listarPorSolicitud');

  Future<Motivo?> obtenerPorId(String id) => _crashService.registrar(() async {
    final doc = await _coleccion.doc(id).get();
    final data = doc.data();
    return data == null ? null : Motivo.fromJson({...data, 'id': doc.id});
  }, 'MotivoService.obtenerPorId');

  Future<String> guardar(Motivo motivo) => _crashService.registrar(() async {
    // El id lo genera el cliente (UUID), igual que en SolicitudService.guardar,
    // para que SQLite y Firestore guarden el mismo documento.
    final docRef = _coleccion.doc(motivo.id);
    await docRef.set(motivo.toJson()..remove('id')).timeout(_tiempoMaximo);
    return docRef.id;
  }, 'MotivoService.guardar');

  Future<void> eliminar(String id) => _crashService.registrar(
    () => _coleccion.doc(id).delete().timeout(_tiempoMaximo),
    'MotivoService.eliminar',
  );
}
