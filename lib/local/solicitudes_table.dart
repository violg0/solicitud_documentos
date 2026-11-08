import 'package:drift/drift.dart';

@DataClassName('SolicitudRow')
class Solicitudes extends Table {
  TextColumn get id => text()();
  TextColumn get idDocumento => text()();
  TextColumn get idUsuario => text()();
  TextColumn get periodo => text()();
  TextColumn get observacionEstudiante =>
      text().withDefault(const Constant(''))();
  TextColumn get estado => text()();
  DateTimeColumn get fechaCreacion => dateTime()();
  DateTimeColumn get fechaModificacion => dateTime()();
  TextColumn get observacionRevision => text().nullable()();
  DateTimeColumn get fechaEntrega => dateTime().nullable()();
  TextColumn get entregadoPor => text().nullable()();
  //debt sync
  BoolColumn get pendingSync => boolean()
                                .withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}