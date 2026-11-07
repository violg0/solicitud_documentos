import 'package:drift/drift.dart';

@DataClassName('SolicitudRow')
class Solicitudes extends Table {
  TextColumn get id => text()();
  TextColumn get idDocumento => text()();
  TextColumn get idUsuario => text()();
  TextColumn get periodo => text()();
  TextColumn get estado => text()();
  //debt sync
  BoolColumn get pendingSync => boolean()
                                .withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}