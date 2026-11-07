// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SolicitudesTable extends Solicitudes
    with TableInfo<$SolicitudesTable, SolicitudRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SolicitudesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idDocumentoMeta = const VerificationMeta(
    'idDocumento',
  );
  @override
  late final GeneratedColumn<String> idDocumento = GeneratedColumn<String>(
    'id_documento',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idUsuarioMeta = const VerificationMeta(
    'idUsuario',
  );
  @override
  late final GeneratedColumn<String> idUsuario = GeneratedColumn<String>(
    'id_usuario',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _periodoMeta = const VerificationMeta(
    'periodo',
  );
  @override
  late final GeneratedColumn<String> periodo = GeneratedColumn<String>(
    'periodo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
    'estado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pendingSyncMeta = const VerificationMeta(
    'pendingSync',
  );
  @override
  late final GeneratedColumn<bool> pendingSync = GeneratedColumn<bool>(
    'pending_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pending_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    idDocumento,
    idUsuario,
    periodo,
    estado,
    pendingSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'solicitudes';
  @override
  VerificationContext validateIntegrity(
    Insertable<SolicitudRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('id_documento')) {
      context.handle(
        _idDocumentoMeta,
        idDocumento.isAcceptableOrUnknown(
          data['id_documento']!,
          _idDocumentoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idDocumentoMeta);
    }
    if (data.containsKey('id_usuario')) {
      context.handle(
        _idUsuarioMeta,
        idUsuario.isAcceptableOrUnknown(data['id_usuario']!, _idUsuarioMeta),
      );
    } else if (isInserting) {
      context.missing(_idUsuarioMeta);
    }
    if (data.containsKey('periodo')) {
      context.handle(
        _periodoMeta,
        periodo.isAcceptableOrUnknown(data['periodo']!, _periodoMeta),
      );
    } else if (isInserting) {
      context.missing(_periodoMeta);
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    } else if (isInserting) {
      context.missing(_estadoMeta);
    }
    if (data.containsKey('pending_sync')) {
      context.handle(
        _pendingSyncMeta,
        pendingSync.isAcceptableOrUnknown(
          data['pending_sync']!,
          _pendingSyncMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SolicitudRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SolicitudRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      idDocumento: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id_documento'],
      )!,
      idUsuario: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id_usuario'],
      )!,
      periodo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}periodo'],
      )!,
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
      )!,
      pendingSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pending_sync'],
      )!,
    );
  }

  @override
  $SolicitudesTable createAlias(String alias) {
    return $SolicitudesTable(attachedDatabase, alias);
  }
}

class SolicitudRow extends DataClass implements Insertable<SolicitudRow> {
  final String id;
  final String idDocumento;
  final String idUsuario;
  final String periodo;
  final String estado;
  final bool pendingSync;
  const SolicitudRow({
    required this.id,
    required this.idDocumento,
    required this.idUsuario,
    required this.periodo,
    required this.estado,
    required this.pendingSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['id_documento'] = Variable<String>(idDocumento);
    map['id_usuario'] = Variable<String>(idUsuario);
    map['periodo'] = Variable<String>(periodo);
    map['estado'] = Variable<String>(estado);
    map['pending_sync'] = Variable<bool>(pendingSync);
    return map;
  }

  SolicitudesCompanion toCompanion(bool nullToAbsent) {
    return SolicitudesCompanion(
      id: Value(id),
      idDocumento: Value(idDocumento),
      idUsuario: Value(idUsuario),
      periodo: Value(periodo),
      estado: Value(estado),
      pendingSync: Value(pendingSync),
    );
  }

  factory SolicitudRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SolicitudRow(
      id: serializer.fromJson<String>(json['id']),
      idDocumento: serializer.fromJson<String>(json['idDocumento']),
      idUsuario: serializer.fromJson<String>(json['idUsuario']),
      periodo: serializer.fromJson<String>(json['periodo']),
      estado: serializer.fromJson<String>(json['estado']),
      pendingSync: serializer.fromJson<bool>(json['pendingSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'idDocumento': serializer.toJson<String>(idDocumento),
      'idUsuario': serializer.toJson<String>(idUsuario),
      'periodo': serializer.toJson<String>(periodo),
      'estado': serializer.toJson<String>(estado),
      'pendingSync': serializer.toJson<bool>(pendingSync),
    };
  }

  SolicitudRow copyWith({
    String? id,
    String? idDocumento,
    String? idUsuario,
    String? periodo,
    String? estado,
    bool? pendingSync,
  }) => SolicitudRow(
    id: id ?? this.id,
    idDocumento: idDocumento ?? this.idDocumento,
    idUsuario: idUsuario ?? this.idUsuario,
    periodo: periodo ?? this.periodo,
    estado: estado ?? this.estado,
    pendingSync: pendingSync ?? this.pendingSync,
  );
  SolicitudRow copyWithCompanion(SolicitudesCompanion data) {
    return SolicitudRow(
      id: data.id.present ? data.id.value : this.id,
      idDocumento: data.idDocumento.present
          ? data.idDocumento.value
          : this.idDocumento,
      idUsuario: data.idUsuario.present ? data.idUsuario.value : this.idUsuario,
      periodo: data.periodo.present ? data.periodo.value : this.periodo,
      estado: data.estado.present ? data.estado.value : this.estado,
      pendingSync: data.pendingSync.present
          ? data.pendingSync.value
          : this.pendingSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SolicitudRow(')
          ..write('id: $id, ')
          ..write('idDocumento: $idDocumento, ')
          ..write('idUsuario: $idUsuario, ')
          ..write('periodo: $periodo, ')
          ..write('estado: $estado, ')
          ..write('pendingSync: $pendingSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, idDocumento, idUsuario, periodo, estado, pendingSync);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SolicitudRow &&
          other.id == this.id &&
          other.idDocumento == this.idDocumento &&
          other.idUsuario == this.idUsuario &&
          other.periodo == this.periodo &&
          other.estado == this.estado &&
          other.pendingSync == this.pendingSync);
}

class SolicitudesCompanion extends UpdateCompanion<SolicitudRow> {
  final Value<String> id;
  final Value<String> idDocumento;
  final Value<String> idUsuario;
  final Value<String> periodo;
  final Value<String> estado;
  final Value<bool> pendingSync;
  final Value<int> rowid;
  const SolicitudesCompanion({
    this.id = const Value.absent(),
    this.idDocumento = const Value.absent(),
    this.idUsuario = const Value.absent(),
    this.periodo = const Value.absent(),
    this.estado = const Value.absent(),
    this.pendingSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SolicitudesCompanion.insert({
    required String id,
    required String idDocumento,
    required String idUsuario,
    required String periodo,
    required String estado,
    this.pendingSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       idDocumento = Value(idDocumento),
       idUsuario = Value(idUsuario),
       periodo = Value(periodo),
       estado = Value(estado);
  static Insertable<SolicitudRow> custom({
    Expression<String>? id,
    Expression<String>? idDocumento,
    Expression<String>? idUsuario,
    Expression<String>? periodo,
    Expression<String>? estado,
    Expression<bool>? pendingSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idDocumento != null) 'id_documento': idDocumento,
      if (idUsuario != null) 'id_usuario': idUsuario,
      if (periodo != null) 'periodo': periodo,
      if (estado != null) 'estado': estado,
      if (pendingSync != null) 'pending_sync': pendingSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SolicitudesCompanion copyWith({
    Value<String>? id,
    Value<String>? idDocumento,
    Value<String>? idUsuario,
    Value<String>? periodo,
    Value<String>? estado,
    Value<bool>? pendingSync,
    Value<int>? rowid,
  }) {
    return SolicitudesCompanion(
      id: id ?? this.id,
      idDocumento: idDocumento ?? this.idDocumento,
      idUsuario: idUsuario ?? this.idUsuario,
      periodo: periodo ?? this.periodo,
      estado: estado ?? this.estado,
      pendingSync: pendingSync ?? this.pendingSync,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (idDocumento.present) {
      map['id_documento'] = Variable<String>(idDocumento.value);
    }
    if (idUsuario.present) {
      map['id_usuario'] = Variable<String>(idUsuario.value);
    }
    if (periodo.present) {
      map['periodo'] = Variable<String>(periodo.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (pendingSync.present) {
      map['pending_sync'] = Variable<bool>(pendingSync.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SolicitudesCompanion(')
          ..write('id: $id, ')
          ..write('idDocumento: $idDocumento, ')
          ..write('idUsuario: $idUsuario, ')
          ..write('periodo: $periodo, ')
          ..write('estado: $estado, ')
          ..write('pendingSync: $pendingSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SolicitudesTable solicitudes = $SolicitudesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [solicitudes];
}

typedef $$SolicitudesTableCreateCompanionBuilder =
    SolicitudesCompanion Function({
      required String id,
      required String idDocumento,
      required String idUsuario,
      required String periodo,
      required String estado,
      Value<bool> pendingSync,
      Value<int> rowid,
    });
typedef $$SolicitudesTableUpdateCompanionBuilder =
    SolicitudesCompanion Function({
      Value<String> id,
      Value<String> idDocumento,
      Value<String> idUsuario,
      Value<String> periodo,
      Value<String> estado,
      Value<bool> pendingSync,
      Value<int> rowid,
    });

class $$SolicitudesTableFilterComposer
    extends Composer<_$AppDatabase, $SolicitudesTable> {
  $$SolicitudesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idDocumento => $composableBuilder(
    column: $table.idDocumento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idUsuario => $composableBuilder(
    column: $table.idUsuario,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get periodo => $composableBuilder(
    column: $table.periodo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pendingSync => $composableBuilder(
    column: $table.pendingSync,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SolicitudesTableOrderingComposer
    extends Composer<_$AppDatabase, $SolicitudesTable> {
  $$SolicitudesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idDocumento => $composableBuilder(
    column: $table.idDocumento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idUsuario => $composableBuilder(
    column: $table.idUsuario,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get periodo => $composableBuilder(
    column: $table.periodo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pendingSync => $composableBuilder(
    column: $table.pendingSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SolicitudesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SolicitudesTable> {
  $$SolicitudesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get idDocumento => $composableBuilder(
    column: $table.idDocumento,
    builder: (column) => column,
  );

  GeneratedColumn<String> get idUsuario =>
      $composableBuilder(column: $table.idUsuario, builder: (column) => column);

  GeneratedColumn<String> get periodo =>
      $composableBuilder(column: $table.periodo, builder: (column) => column);

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<bool> get pendingSync => $composableBuilder(
    column: $table.pendingSync,
    builder: (column) => column,
  );
}

class $$SolicitudesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SolicitudesTable,
          SolicitudRow,
          $$SolicitudesTableFilterComposer,
          $$SolicitudesTableOrderingComposer,
          $$SolicitudesTableAnnotationComposer,
          $$SolicitudesTableCreateCompanionBuilder,
          $$SolicitudesTableUpdateCompanionBuilder,
          (
            SolicitudRow,
            BaseReferences<_$AppDatabase, $SolicitudesTable, SolicitudRow>,
          ),
          SolicitudRow,
          PrefetchHooks Function()
        > {
  $$SolicitudesTableTableManager(_$AppDatabase db, $SolicitudesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SolicitudesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SolicitudesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SolicitudesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> idDocumento = const Value.absent(),
                Value<String> idUsuario = const Value.absent(),
                Value<String> periodo = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<bool> pendingSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SolicitudesCompanion(
                id: id,
                idDocumento: idDocumento,
                idUsuario: idUsuario,
                periodo: periodo,
                estado: estado,
                pendingSync: pendingSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String idDocumento,
                required String idUsuario,
                required String periodo,
                required String estado,
                Value<bool> pendingSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SolicitudesCompanion.insert(
                id: id,
                idDocumento: idDocumento,
                idUsuario: idUsuario,
                periodo: periodo,
                estado: estado,
                pendingSync: pendingSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SolicitudesTable, SolicitudRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SolicitudesTable,
                    SolicitudRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SolicitudesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SolicitudesTable,
      SolicitudRow,
      $$SolicitudesTableFilterComposer,
      $$SolicitudesTableOrderingComposer,
      $$SolicitudesTableAnnotationComposer,
      $$SolicitudesTableCreateCompanionBuilder,
      $$SolicitudesTableUpdateCompanionBuilder,
      (
        SolicitudRow,
        BaseReferences<_$AppDatabase, $SolicitudesTable, SolicitudRow>,
      ),
      SolicitudRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SolicitudesTableTableManager get solicitudes =>
      $$SolicitudesTableTableManager(_db, _db.solicitudes);
}
