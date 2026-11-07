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
  int get schemaVersion => 2;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'solicitudes.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}