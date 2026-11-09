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
    fechaCreacion: row.fechaCreacion.toUtc(),
    fechaModificacion: row.fechaModificacion.toUtc(),
    observacionRevision: row.observacionRevision,
    fechaEntrega: row.fechaEntrega?.toUtc(),
    entregadoPor: row.entregadoPor,
  );

  /// Si [idUsuario] no es null solo devuelve las de esa cuenta: así una cuenta
  /// no ve lo que otra dejó en el mismo dispositivo. Con null (revisor y
  /// secretaria, que leen todas) devuelve toda la copia local.
  Future<List<Solicitud>> getSolicitudes({String? idUsuario}) async {
    final consulta = db.select(db.solicitudes);
    if (idUsuario != null) {
      consulta.where((t) => t.idUsuario.equals(idUsuario));
    }
    final rows = await consulta.get();
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

  /// Pendientes de subir a Firestore; con [idUsuario] solo los de esa cuenta.
  Future<List<Solicitud>> getPendingSolicitudes({String? idUsuario}) async {
    final consulta = db.select(db.solicitudes)
      ..where((t) => t.pendingSync.equals(true));
    if (idUsuario != null) {
      consulta.where((t) => t.idUsuario.equals(idUsuario));
    }
    final rows = await consulta.get();
    return rows.map(_toDomain).toList();
  }

  /// Ids con `pendingSync = true`, para marcarlos en la lista.
  Future<Set<String>> getIdsPendientes({String? idUsuario}) async {
    final pendientes = await getPendingSolicitudes(idUsuario: idUsuario);
    return {for (final s in pendientes) s.id};
  }

  Future<void> markSynced(String id) async {
    await (db.update(db.solicitudes)..where((t) => t.id.equals(id)))
        .write(const SolicitudesCompanion(pendingSync: Value(false)));
  }

  /// Borra la copia local ya sincronizada (se llama al cerrar sesión). Las
  /// pendientes se conservan para no perder una solicitud que aún no subió;
  /// siguen aisladas porque toda lectura y sincronización filtra por cuenta.
  Future<void> borrarSincronizadas() async {
    await (db.delete(db.solicitudes)
          ..where((t) => t.pendingSync.equals(false)))
        .go();
  }
}
