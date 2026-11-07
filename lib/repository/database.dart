import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

@DataClassName('NotaOffline')
class NotasOffline extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get idProducto => integer()();

  IntColumn get priority => integer()
      .withDefault(const Constant(1))
      .check(priority.isBetweenValues(2, 5))();
  TextColumn get texto => text()();

  BoolColumn get pendingSync => boolean().withDefault(const Constant(true))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [NotasOffline])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'tienda'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

final db = AppDatabase(); // aqui esta el appdatabase
