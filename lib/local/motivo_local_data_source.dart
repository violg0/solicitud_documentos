import 'package:drift/drift.dart';
import '../models/motivo.dart';
import '../models/estados.dart';
import 'app_database.dart';

class MotivoLocalDataSource {
  final AppDatabase db;

  MotivoLocalDataSource(this.db);

  Motivo _toDomain(MotivoRow row) {
    return Motivo(
      id: row.id,
      idSolicitud: row.idSolicitud,
      mensaje: row.mensaje,
      estado: EstadoSolicitud.values.byName(row.estado),
      fechaCreacion: row.fechaCreacion,
    );
  }

  Future<void> saveMotivo(Motivo motivo) async {
    await db.into(db.motivos).insertOnConflictUpdate(
      MotivosCompanion.insert(
        id: motivo.id,
        idSolicitud: motivo.idSolicitud,
        mensaje: motivo.mensaje,
        estado: motivo.estado.name,
        fechaCreacion: motivo.fechaCreacion,
        pendingSync: const Value(true),
      ),
    );
  }

  Future<List<Motivo>> getMotivosPorSolicitud(String idSolicitud) async {
    final rows = await (db.select(db.motivos)
          ..where((t) => t.idSolicitud.equals(idSolicitud)))
        .get();
    return rows.map(_toDomain).toList();
  }
}