import 'package:drift/drift.dart';
import '../models/solicitud.dart';
import '../models/estados.dart';
import 'app_database.dart';

class SolicitudLocalDataSource {
  final AppDatabase db;
  SolicitudLocalDataSource(this.db);

  Solicitud _toDomain(SolicitudRow row) => Solicitud(
    id: row.id,
    idDocumento: row.idDocumento,
    idUsuario: row.idUsuario,
    periodo: row.periodo,
    observacionEstudiante: row.observacionEstudiante,
    estado: EstadoSolicitud.values.byName(row.estado),
    fechaCreacion: row.fechaCreacion,
    fechaModificacion: row.fechaModificacion,
    observacionRevision: row.observacionRevision,
    fechaEntrega: row.fechaEntrega,
    entregadoPor: row.entregadoPor,
  );

  Future<List<Solicitud>> getSolicitudes() async {
    final rows = await db.select(db.solicitudes).get();
    return rows.map(_toDomain).toList();
  }

  Future<void> saveSolicitud(Solicitud s) async {
    await db.into(db.solicitudes).insertOnConflictUpdate(
      SolicitudesCompanion.insert(
        id: s.id,
        idDocumento: s.idDocumento,
        idUsuario: s.idUsuario,
        periodo: s.periodo,
        observacionEstudiante: Value(s.observacionEstudiante),
        estado: s.estado.name,
        fechaCreacion: s.fechaCreacion,
        fechaModificacion: s.fechaModificacion,
        observacionRevision: Value(s.observacionRevision),
        fechaEntrega: Value(s.fechaEntrega),
        entregadoPor: Value(s.entregadoPor),
        pendingSync: const Value(true),
      ),
    );
  }

  Future<List<Solicitud>> getPendingSolicitudes() async {
    final rows = await (db.select(db.solicitudes)
          ..where((t) => t.pendingSync.equals(true)))
        .get();
    return rows.map(_toDomain).toList();
  }

  Future<void> markSynced(String id) async {
    await (db.update(db.solicitudes)..where((t) => t.id.equals(id)))
        .write(const SolicitudesCompanion(pendingSync: Value(false)));
  }
}