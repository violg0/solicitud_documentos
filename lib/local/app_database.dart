import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'solicitudes_table.dart';
import 'motivos_table.dart';
import 'documentos_table.dart';
part 'app_database.g.dart';

@DriftDatabase(tables: [Solicitudes, Motivos, Documentos])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.executor);
  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 3) {
        // Crea las tablas que falten (sin tocar las existentes).
        for (final TableInfo tabla in [solicitudes, motivos, documentos]) {
          final existe = await customSelect(
            "SELECT 1 FROM sqlite_master WHERE type = 'table' AND name = ?",
            variables: [Variable.withString(tabla.actualTableName)],
          ).get();
          if (existe.isEmpty) await m.createTable(tabla);
        }
        if (from < 4) {
          await _agregarColumna(
            'solicitudes',
            'observacion_estudiante',
            "TEXT NOT NULL DEFAULT ''",
          );
          await _agregarColumna(
            'solicitudes',
            'fecha_creacion',
            'INTEGER NOT NULL DEFAULT 0',
          );
          await _agregarColumna(
            'solicitudes',
            'observacion_revision',
            'TEXT',
          );
          await _agregarColumna('solicitudes', 'fecha_entrega', 'INTEGER');
          await _agregarColumna('solicitudes', 'entregado_por', 'TEXT');
        }
        // Agrega las columnas que falten, conservando los datos.
        await _agregarColumna('solicitudes', 'fecha_modificacion',
            'INTEGER NOT NULL DEFAULT 0');
        await _agregarColumna(
            'solicitudes', 'pending_sync', 'INTEGER NOT NULL DEFAULT 1');
        await _agregarColumna('documentos', 'imagen', "TEXT NOT NULL DEFAULT ''");
        await _agregarColumna(
            'documentos', 'pending_sync', 'INTEGER NOT NULL DEFAULT 1');
        await _agregarColumna(
            'motivos', 'pending_sync', 'INTEGER NOT NULL DEFAULT 1');
      }
    },
  );

  Future<void> _agregarColumna(
    String tabla,
    String columna,
    String definicion,
  ) async {
    final columnas = await customSelect('PRAGMA table_info($tabla)').get();
    if (columnas.any((c) => c.read<String>('name') == columna)) return;
    await customStatement('ALTER TABLE $tabla ADD COLUMN $columna $definicion');
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'solicitudes.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}