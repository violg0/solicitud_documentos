import 'app_database.dart';
import '../models/documento.dart';
import 'package:drift/drift.dart';


class DocumentoLocalDataSource {
  final AppDatabase db;

  DocumentoLocalDataSource(this.db);

  Documento _toDomain(DocumentoRow row) {
    return Documento(
      id: row.id,
      nombre: row.nombre,
      descripcion: row.descripcion,
      imagen: row.imagen,
      habilitado: row.habilitado,
    );
  }

  Future<void> saveDocumento (Documento documento) async {
    await db.into(db.documentos).insertOnConflictUpdate(
      DocumentosCompanion.insert(
        id: documento.id,
        nombre: documento.nombre,
        descripcion: documento.descripcion,
        imagen: Value(documento.imagen),
        habilitado: Value(documento.habilitado),
        pendingSync: const Value(true),
      ),
    );

  }

  Future<List<Documento>> getDocumentos () async{
    final rows = await db.select(db.documentos).get();
    return rows.map(_toDomain).toList();
  }

  Future<Documento?> getDocumentoPorId(String id) async {
    final row = await (db.select(db.documentos)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }
}