import 'package:drift/drift.dart';

@DataClassName('DocumentoRow')
class Documentos extends Table {
  TextColumn get id => text()();
  TextColumn get nombre => text()();
  TextColumn get descripcion => text()();
  TextColumn get imagen => text().withDefault(const Constant(''))();
  BoolColumn get habilitado => boolean()
                                .withDefault(const Constant(true))();

  //debt sync
  BoolColumn get pendingSync => boolean()
                                .withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}