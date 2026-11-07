import 'package:drift/drift.dart';

@DataClassName('MotivoRow')
class Motivos extends Table {
  TextColumn get id => text()();
  TextColumn get idSolicitud => text()();
  TextColumn get mensaje => text()();
  TextColumn get estado => text()();
  DateTimeColumn get fechaCreacion => dateTime()();
  //debt sync
  BoolColumn get pendingSync => boolean()
                                .withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}