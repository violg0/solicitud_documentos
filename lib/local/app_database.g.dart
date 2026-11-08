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
  static const VerificationMeta _observacionEstudianteMeta =
      const VerificationMeta('observacionEstudiante');
  @override
  late final GeneratedColumn<String> observacionEstudiante =
      GeneratedColumn<String>(
        'observacion_estudiante',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
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
  static const VerificationMeta _fechaCreacionMeta = const VerificationMeta(
    'fechaCreacion',
  );
  @override
  late final GeneratedColumn<DateTime> fechaCreacion =
      GeneratedColumn<DateTime>(
        'fecha_creacion',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _fechaModificacionMeta = const VerificationMeta(
    'fechaModificacion',
  );
  @override
  late final GeneratedColumn<DateTime> fechaModificacion =
      GeneratedColumn<DateTime>(
        'fecha_modificacion',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _observacionRevisionMeta =
      const VerificationMeta('observacionRevision');
  @override
  late final GeneratedColumn<String> observacionRevision =
      GeneratedColumn<String>(
        'observacion_revision',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _fechaEntregaMeta = const VerificationMeta(
    'fechaEntrega',
  );
  @override
  late final GeneratedColumn<DateTime> fechaEntrega = GeneratedColumn<DateTime>(
    'fecha_entrega',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _entregadoPorMeta = const VerificationMeta(
    'entregadoPor',
  );
  @override
  late final GeneratedColumn<String> entregadoPor = GeneratedColumn<String>(
    'entregado_por',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    observacionEstudiante,
    estado,
    fechaCreacion,
    fechaModificacion,
    observacionRevision,
    fechaEntrega,
    entregadoPor,
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
    if (data.containsKey('observacion_estudiante')) {
      context.handle(
        _observacionEstudianteMeta,
        observacionEstudiante.isAcceptableOrUnknown(
          data['observacion_estudiante']!,
          _observacionEstudianteMeta,
        ),
      );
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    } else if (isInserting) {
      context.missing(_estadoMeta);
    }
    if (data.containsKey('fecha_creacion')) {
      context.handle(
        _fechaCreacionMeta,
        fechaCreacion.isAcceptableOrUnknown(
          data['fecha_creacion']!,
          _fechaCreacionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaCreacionMeta);
    }
    if (data.containsKey('fecha_modificacion')) {
      context.handle(
        _fechaModificacionMeta,
        fechaModificacion.isAcceptableOrUnknown(
          data['fecha_modificacion']!,
          _fechaModificacionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaModificacionMeta);
    }
    if (data.containsKey('observacion_revision')) {
      context.handle(
        _observacionRevisionMeta,
        observacionRevision.isAcceptableOrUnknown(
          data['observacion_revision']!,
          _observacionRevisionMeta,
        ),
      );
    }
    if (data.containsKey('fecha_entrega')) {
      context.handle(
        _fechaEntregaMeta,
        fechaEntrega.isAcceptableOrUnknown(
          data['fecha_entrega']!,
          _fechaEntregaMeta,
        ),
      );
    }
    if (data.containsKey('entregado_por')) {
      context.handle(
        _entregadoPorMeta,
        entregadoPor.isAcceptableOrUnknown(
          data['entregado_por']!,
          _entregadoPorMeta,
        ),
      );
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
      observacionEstudiante: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observacion_estudiante'],
      )!,
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
      )!,
      fechaCreacion: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_creacion'],
      )!,
      fechaModificacion: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_modificacion'],
      )!,
      observacionRevision: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observacion_revision'],
      ),
      fechaEntrega: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_entrega'],
      ),
      entregadoPor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entregado_por'],
      ),
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
  final String observacionEstudiante;
  final String estado;
  final DateTime fechaCreacion;
  final DateTime fechaModificacion;
  final String? observacionRevision;
  final DateTime? fechaEntrega;
  final String? entregadoPor;
  final bool pendingSync;
  const SolicitudRow({
    required this.id,
    required this.idDocumento,
    required this.idUsuario,
    required this.periodo,
    required this.observacionEstudiante,
    required this.estado,
    required this.fechaCreacion,
    required this.fechaModificacion,
    this.observacionRevision,
    this.fechaEntrega,
    this.entregadoPor,
    required this.pendingSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['id_documento'] = Variable<String>(idDocumento);
    map['id_usuario'] = Variable<String>(idUsuario);
    map['periodo'] = Variable<String>(periodo);
    map['observacion_estudiante'] = Variable<String>(observacionEstudiante);
    map['estado'] = Variable<String>(estado);
    map['fecha_creacion'] = Variable<DateTime>(fechaCreacion);
    map['fecha_modificacion'] = Variable<DateTime>(fechaModificacion);
    if (!nullToAbsent || observacionRevision != null) {
      map['observacion_revision'] = Variable<String>(observacionRevision);
    }
    if (!nullToAbsent || fechaEntrega != null) {
      map['fecha_entrega'] = Variable<DateTime>(fechaEntrega);
    }
    if (!nullToAbsent || entregadoPor != null) {
      map['entregado_por'] = Variable<String>(entregadoPor);
    }
    map['pending_sync'] = Variable<bool>(pendingSync);
    return map;
  }

  SolicitudesCompanion toCompanion(bool nullToAbsent) {
    return SolicitudesCompanion(
      id: Value(id),
      idDocumento: Value(idDocumento),
      idUsuario: Value(idUsuario),
      periodo: Value(periodo),
      observacionEstudiante: Value(observacionEstudiante),
      estado: Value(estado),
      fechaCreacion: Value(fechaCreacion),
      fechaModificacion: Value(fechaModificacion),
      observacionRevision: observacionRevision == null && nullToAbsent
          ? const Value.absent()
          : Value(observacionRevision),
      fechaEntrega: fechaEntrega == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaEntrega),
      entregadoPor: entregadoPor == null && nullToAbsent
          ? const Value.absent()
          : Value(entregadoPor),
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
      observacionEstudiante: serializer.fromJson<String>(
        json['observacionEstudiante'],
      ),
      estado: serializer.fromJson<String>(json['estado']),
      fechaCreacion: serializer.fromJson<DateTime>(json['fechaCreacion']),
      fechaModificacion: serializer.fromJson<DateTime>(
        json['fechaModificacion'],
      ),
      observacionRevision: serializer.fromJson<String?>(
        json['observacionRevision'],
      ),
      fechaEntrega: serializer.fromJson<DateTime?>(json['fechaEntrega']),
      entregadoPor: serializer.fromJson<String?>(json['entregadoPor']),
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
      'observacionEstudiante': serializer.toJson<String>(observacionEstudiante),
      'estado': serializer.toJson<String>(estado),
      'fechaCreacion': serializer.toJson<DateTime>(fechaCreacion),
      'fechaModificacion': serializer.toJson<DateTime>(fechaModificacion),
      'observacionRevision': serializer.toJson<String?>(observacionRevision),
      'fechaEntrega': serializer.toJson<DateTime?>(fechaEntrega),
      'entregadoPor': serializer.toJson<String?>(entregadoPor),
      'pendingSync': serializer.toJson<bool>(pendingSync),
    };
  }

  SolicitudRow copyWith({
    String? id,
    String? idDocumento,
    String? idUsuario,
    String? periodo,
    String? observacionEstudiante,
    String? estado,
    DateTime? fechaCreacion,
    DateTime? fechaModificacion,
    Value<String?> observacionRevision = const Value.absent(),
    Value<DateTime?> fechaEntrega = const Value.absent(),
    Value<String?> entregadoPor = const Value.absent(),
    bool? pendingSync,
  }) => SolicitudRow(
    id: id ?? this.id,
    idDocumento: idDocumento ?? this.idDocumento,
    idUsuario: idUsuario ?? this.idUsuario,
    periodo: periodo ?? this.periodo,
    observacionEstudiante: observacionEstudiante ?? this.observacionEstudiante,
    estado: estado ?? this.estado,
    fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    fechaModificacion: fechaModificacion ?? this.fechaModificacion,
    observacionRevision: observacionRevision.present
        ? observacionRevision.value
        : this.observacionRevision,
    fechaEntrega: fechaEntrega.present ? fechaEntrega.value : this.fechaEntrega,
    entregadoPor: entregadoPor.present ? entregadoPor.value : this.entregadoPor,
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
      observacionEstudiante: data.observacionEstudiante.present
          ? data.observacionEstudiante.value
          : this.observacionEstudiante,
      estado: data.estado.present ? data.estado.value : this.estado,
      fechaCreacion: data.fechaCreacion.present
          ? data.fechaCreacion.value
          : this.fechaCreacion,
      fechaModificacion: data.fechaModificacion.present
          ? data.fechaModificacion.value
          : this.fechaModificacion,
      observacionRevision: data.observacionRevision.present
          ? data.observacionRevision.value
          : this.observacionRevision,
      fechaEntrega: data.fechaEntrega.present
          ? data.fechaEntrega.value
          : this.fechaEntrega,
      entregadoPor: data.entregadoPor.present
          ? data.entregadoPor.value
          : this.entregadoPor,
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
          ..write('observacionEstudiante: $observacionEstudiante, ')
          ..write('estado: $estado, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaModificacion: $fechaModificacion, ')
          ..write('observacionRevision: $observacionRevision, ')
          ..write('fechaEntrega: $fechaEntrega, ')
          ..write('entregadoPor: $entregadoPor, ')
          ..write('pendingSync: $pendingSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    idDocumento,
    idUsuario,
    periodo,
    observacionEstudiante,
    estado,
    fechaCreacion,
    fechaModificacion,
    observacionRevision,
    fechaEntrega,
    entregadoPor,
    pendingSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SolicitudRow &&
          other.id == this.id &&
          other.idDocumento == this.idDocumento &&
          other.idUsuario == this.idUsuario &&
          other.periodo == this.periodo &&
          other.observacionEstudiante == this.observacionEstudiante &&
          other.estado == this.estado &&
          other.fechaCreacion == this.fechaCreacion &&
          other.fechaModificacion == this.fechaModificacion &&
          other.observacionRevision == this.observacionRevision &&
          other.fechaEntrega == this.fechaEntrega &&
          other.entregadoPor == this.entregadoPor &&
          other.pendingSync == this.pendingSync);
}

class SolicitudesCompanion extends UpdateCompanion<SolicitudRow> {
  final Value<String> id;
  final Value<String> idDocumento;
  final Value<String> idUsuario;
  final Value<String> periodo;
  final Value<String> observacionEstudiante;
  final Value<String> estado;
  final Value<DateTime> fechaCreacion;
  final Value<DateTime> fechaModificacion;
  final Value<String?> observacionRevision;
  final Value<DateTime?> fechaEntrega;
  final Value<String?> entregadoPor;
  final Value<bool> pendingSync;
  final Value<int> rowid;
  const SolicitudesCompanion({
    this.id = const Value.absent(),
    this.idDocumento = const Value.absent(),
    this.idUsuario = const Value.absent(),
    this.periodo = const Value.absent(),
    this.observacionEstudiante = const Value.absent(),
    this.estado = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.fechaModificacion = const Value.absent(),
    this.observacionRevision = const Value.absent(),
    this.fechaEntrega = const Value.absent(),
    this.entregadoPor = const Value.absent(),
    this.pendingSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SolicitudesCompanion.insert({
    required String id,
    required String idDocumento,
    required String idUsuario,
    required String periodo,
    this.observacionEstudiante = const Value.absent(),
    required String estado,
    required DateTime fechaCreacion,
    required DateTime fechaModificacion,
    this.observacionRevision = const Value.absent(),
    this.fechaEntrega = const Value.absent(),
    this.entregadoPor = const Value.absent(),
    this.pendingSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       idDocumento = Value(idDocumento),
       idUsuario = Value(idUsuario),
       periodo = Value(periodo),
       estado = Value(estado),
       fechaCreacion = Value(fechaCreacion),
       fechaModificacion = Value(fechaModificacion);
  static Insertable<SolicitudRow> custom({
    Expression<String>? id,
    Expression<String>? idDocumento,
    Expression<String>? idUsuario,
    Expression<String>? periodo,
    Expression<String>? observacionEstudiante,
    Expression<String>? estado,
    Expression<DateTime>? fechaCreacion,
    Expression<DateTime>? fechaModificacion,
    Expression<String>? observacionRevision,
    Expression<DateTime>? fechaEntrega,
    Expression<String>? entregadoPor,
    Expression<bool>? pendingSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idDocumento != null) 'id_documento': idDocumento,
      if (idUsuario != null) 'id_usuario': idUsuario,
      if (periodo != null) 'periodo': periodo,
      if (observacionEstudiante != null)
        'observacion_estudiante': observacionEstudiante,
      if (estado != null) 'estado': estado,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
      if (fechaModificacion != null) 'fecha_modificacion': fechaModificacion,
      if (observacionRevision != null)
        'observacion_revision': observacionRevision,
      if (fechaEntrega != null) 'fecha_entrega': fechaEntrega,
      if (entregadoPor != null) 'entregado_por': entregadoPor,
      if (pendingSync != null) 'pending_sync': pendingSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SolicitudesCompanion copyWith({
    Value<String>? id,
    Value<String>? idDocumento,
    Value<String>? idUsuario,
    Value<String>? periodo,
    Value<String>? observacionEstudiante,
    Value<String>? estado,
    Value<DateTime>? fechaCreacion,
    Value<DateTime>? fechaModificacion,
    Value<String?>? observacionRevision,
    Value<DateTime?>? fechaEntrega,
    Value<String?>? entregadoPor,
    Value<bool>? pendingSync,
    Value<int>? rowid,
  }) {
    return SolicitudesCompanion(
      id: id ?? this.id,
      idDocumento: idDocumento ?? this.idDocumento,
      idUsuario: idUsuario ?? this.idUsuario,
      periodo: periodo ?? this.periodo,
      observacionEstudiante:
          observacionEstudiante ?? this.observacionEstudiante,
      estado: estado ?? this.estado,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaModificacion: fechaModificacion ?? this.fechaModificacion,
      observacionRevision: observacionRevision ?? this.observacionRevision,
      fechaEntrega: fechaEntrega ?? this.fechaEntrega,
      entregadoPor: entregadoPor ?? this.entregadoPor,
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
    if (observacionEstudiante.present) {
      map['observacion_estudiante'] = Variable<String>(
        observacionEstudiante.value,
      );
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (fechaCreacion.present) {
      map['fecha_creacion'] = Variable<DateTime>(fechaCreacion.value);
    }
    if (fechaModificacion.present) {
      map['fecha_modificacion'] = Variable<DateTime>(fechaModificacion.value);
    }
    if (observacionRevision.present) {
      map['observacion_revision'] = Variable<String>(observacionRevision.value);
    }
    if (fechaEntrega.present) {
      map['fecha_entrega'] = Variable<DateTime>(fechaEntrega.value);
    }
    if (entregadoPor.present) {
      map['entregado_por'] = Variable<String>(entregadoPor.value);
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
          ..write('observacionEstudiante: $observacionEstudiante, ')
          ..write('estado: $estado, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaModificacion: $fechaModificacion, ')
          ..write('observacionRevision: $observacionRevision, ')
          ..write('fechaEntrega: $fechaEntrega, ')
          ..write('entregadoPor: $entregadoPor, ')
          ..write('pendingSync: $pendingSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MotivosTable extends Motivos with TableInfo<$MotivosTable, MotivoRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MotivosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idSolicitudMeta = const VerificationMeta(
    'idSolicitud',
  );
  @override
  late final GeneratedColumn<String> idSolicitud = GeneratedColumn<String>(
    'id_solicitud',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mensajeMeta = const VerificationMeta(
    'mensaje',
  );
  @override
  late final GeneratedColumn<String> mensaje = GeneratedColumn<String>(
    'mensaje',
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
  static const VerificationMeta _fechaCreacionMeta = const VerificationMeta(
    'fechaCreacion',
  );
  @override
  late final GeneratedColumn<DateTime> fechaCreacion =
      GeneratedColumn<DateTime>(
        'fecha_creacion',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
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
    idSolicitud,
    mensaje,
    estado,
    fechaCreacion,
    pendingSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'motivos';
  @override
  VerificationContext validateIntegrity(
    Insertable<MotivoRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('id_solicitud')) {
      context.handle(
        _idSolicitudMeta,
        idSolicitud.isAcceptableOrUnknown(
          data['id_solicitud']!,
          _idSolicitudMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idSolicitudMeta);
    }
    if (data.containsKey('mensaje')) {
      context.handle(
        _mensajeMeta,
        mensaje.isAcceptableOrUnknown(data['mensaje']!, _mensajeMeta),
      );
    } else if (isInserting) {
      context.missing(_mensajeMeta);
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    } else if (isInserting) {
      context.missing(_estadoMeta);
    }
    if (data.containsKey('fecha_creacion')) {
      context.handle(
        _fechaCreacionMeta,
        fechaCreacion.isAcceptableOrUnknown(
          data['fecha_creacion']!,
          _fechaCreacionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaCreacionMeta);
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
  MotivoRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MotivoRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      idSolicitud: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id_solicitud'],
      )!,
      mensaje: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mensaje'],
      )!,
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
      )!,
      fechaCreacion: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_creacion'],
      )!,
      pendingSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pending_sync'],
      )!,
    );
  }

  @override
  $MotivosTable createAlias(String alias) {
    return $MotivosTable(attachedDatabase, alias);
  }
}

class MotivoRow extends DataClass implements Insertable<MotivoRow> {
  final String id;
  final String idSolicitud;
  final String mensaje;
  final String estado;
  final DateTime fechaCreacion;
  final bool pendingSync;
  const MotivoRow({
    required this.id,
    required this.idSolicitud,
    required this.mensaje,
    required this.estado,
    required this.fechaCreacion,
    required this.pendingSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['id_solicitud'] = Variable<String>(idSolicitud);
    map['mensaje'] = Variable<String>(mensaje);
    map['estado'] = Variable<String>(estado);
    map['fecha_creacion'] = Variable<DateTime>(fechaCreacion);
    map['pending_sync'] = Variable<bool>(pendingSync);
    return map;
  }

  MotivosCompanion toCompanion(bool nullToAbsent) {
    return MotivosCompanion(
      id: Value(id),
      idSolicitud: Value(idSolicitud),
      mensaje: Value(mensaje),
      estado: Value(estado),
      fechaCreacion: Value(fechaCreacion),
      pendingSync: Value(pendingSync),
    );
  }

  factory MotivoRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MotivoRow(
      id: serializer.fromJson<String>(json['id']),
      idSolicitud: serializer.fromJson<String>(json['idSolicitud']),
      mensaje: serializer.fromJson<String>(json['mensaje']),
      estado: serializer.fromJson<String>(json['estado']),
      fechaCreacion: serializer.fromJson<DateTime>(json['fechaCreacion']),
      pendingSync: serializer.fromJson<bool>(json['pendingSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'idSolicitud': serializer.toJson<String>(idSolicitud),
      'mensaje': serializer.toJson<String>(mensaje),
      'estado': serializer.toJson<String>(estado),
      'fechaCreacion': serializer.toJson<DateTime>(fechaCreacion),
      'pendingSync': serializer.toJson<bool>(pendingSync),
    };
  }

  MotivoRow copyWith({
    String? id,
    String? idSolicitud,
    String? mensaje,
    String? estado,
    DateTime? fechaCreacion,
    bool? pendingSync,
  }) => MotivoRow(
    id: id ?? this.id,
    idSolicitud: idSolicitud ?? this.idSolicitud,
    mensaje: mensaje ?? this.mensaje,
    estado: estado ?? this.estado,
    fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    pendingSync: pendingSync ?? this.pendingSync,
  );
  MotivoRow copyWithCompanion(MotivosCompanion data) {
    return MotivoRow(
      id: data.id.present ? data.id.value : this.id,
      idSolicitud: data.idSolicitud.present
          ? data.idSolicitud.value
          : this.idSolicitud,
      mensaje: data.mensaje.present ? data.mensaje.value : this.mensaje,
      estado: data.estado.present ? data.estado.value : this.estado,
      fechaCreacion: data.fechaCreacion.present
          ? data.fechaCreacion.value
          : this.fechaCreacion,
      pendingSync: data.pendingSync.present
          ? data.pendingSync.value
          : this.pendingSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MotivoRow(')
          ..write('id: $id, ')
          ..write('idSolicitud: $idSolicitud, ')
          ..write('mensaje: $mensaje, ')
          ..write('estado: $estado, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('pendingSync: $pendingSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, idSolicitud, mensaje, estado, fechaCreacion, pendingSync);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MotivoRow &&
          other.id == this.id &&
          other.idSolicitud == this.idSolicitud &&
          other.mensaje == this.mensaje &&
          other.estado == this.estado &&
          other.fechaCreacion == this.fechaCreacion &&
          other.pendingSync == this.pendingSync);
}

class MotivosCompanion extends UpdateCompanion<MotivoRow> {
  final Value<String> id;
  final Value<String> idSolicitud;
  final Value<String> mensaje;
  final Value<String> estado;
  final Value<DateTime> fechaCreacion;
  final Value<bool> pendingSync;
  final Value<int> rowid;
  const MotivosCompanion({
    this.id = const Value.absent(),
    this.idSolicitud = const Value.absent(),
    this.mensaje = const Value.absent(),
    this.estado = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.pendingSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MotivosCompanion.insert({
    required String id,
    required String idSolicitud,
    required String mensaje,
    required String estado,
    required DateTime fechaCreacion,
    this.pendingSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       idSolicitud = Value(idSolicitud),
       mensaje = Value(mensaje),
       estado = Value(estado),
       fechaCreacion = Value(fechaCreacion);
  static Insertable<MotivoRow> custom({
    Expression<String>? id,
    Expression<String>? idSolicitud,
    Expression<String>? mensaje,
    Expression<String>? estado,
    Expression<DateTime>? fechaCreacion,
    Expression<bool>? pendingSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idSolicitud != null) 'id_solicitud': idSolicitud,
      if (mensaje != null) 'mensaje': mensaje,
      if (estado != null) 'estado': estado,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
      if (pendingSync != null) 'pending_sync': pendingSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MotivosCompanion copyWith({
    Value<String>? id,
    Value<String>? idSolicitud,
    Value<String>? mensaje,
    Value<String>? estado,
    Value<DateTime>? fechaCreacion,
    Value<bool>? pendingSync,
    Value<int>? rowid,
  }) {
    return MotivosCompanion(
      id: id ?? this.id,
      idSolicitud: idSolicitud ?? this.idSolicitud,
      mensaje: mensaje ?? this.mensaje,
      estado: estado ?? this.estado,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
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
    if (idSolicitud.present) {
      map['id_solicitud'] = Variable<String>(idSolicitud.value);
    }
    if (mensaje.present) {
      map['mensaje'] = Variable<String>(mensaje.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (fechaCreacion.present) {
      map['fecha_creacion'] = Variable<DateTime>(fechaCreacion.value);
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
    return (StringBuffer('MotivosCompanion(')
          ..write('id: $id, ')
          ..write('idSolicitud: $idSolicitud, ')
          ..write('mensaje: $mensaje, ')
          ..write('estado: $estado, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('pendingSync: $pendingSync, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DocumentosTable extends Documentos
    with TableInfo<$DocumentosTable, DocumentoRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descripcionMeta = const VerificationMeta(
    'descripcion',
  );
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
    'descripcion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imagenMeta = const VerificationMeta('imagen');
  @override
  late final GeneratedColumn<String> imagen = GeneratedColumn<String>(
    'imagen',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _habilitadoMeta = const VerificationMeta(
    'habilitado',
  );
  @override
  late final GeneratedColumn<bool> habilitado = GeneratedColumn<bool>(
    'habilitado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("habilitado" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
    nombre,
    descripcion,
    imagen,
    habilitado,
    pendingSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'documentos';
  @override
  VerificationContext validateIntegrity(
    Insertable<DocumentoRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
        _descripcionMeta,
        descripcion.isAcceptableOrUnknown(
          data['descripcion']!,
          _descripcionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descripcionMeta);
    }
    if (data.containsKey('imagen')) {
      context.handle(
        _imagenMeta,
        imagen.isAcceptableOrUnknown(data['imagen']!, _imagenMeta),
      );
    }
    if (data.containsKey('habilitado')) {
      context.handle(
        _habilitadoMeta,
        habilitado.isAcceptableOrUnknown(data['habilitado']!, _habilitadoMeta),
      );
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
  DocumentoRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentoRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      )!,
      imagen: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}imagen'],
      )!,
      habilitado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}habilitado'],
      )!,
      pendingSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pending_sync'],
      )!,
    );
  }

  @override
  $DocumentosTable createAlias(String alias) {
    return $DocumentosTable(attachedDatabase, alias);
  }
}

class DocumentoRow extends DataClass implements Insertable<DocumentoRow> {
  final String id;
  final String nombre;
  final String descripcion;
  final String imagen;
  final bool habilitado;
  final bool pendingSync;
  const DocumentoRow({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.imagen,
    required this.habilitado,
    required this.pendingSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    map['descripcion'] = Variable<String>(descripcion);
    map['imagen'] = Variable<String>(imagen);
    map['habilitado'] = Variable<bool>(habilitado);
    map['pending_sync'] = Variable<bool>(pendingSync);
    return map;
  }

  DocumentosCompanion toCompanion(bool nullToAbsent) {
    return DocumentosCompanion(
      id: Value(id),
      nombre: Value(nombre),
      descripcion: Value(descripcion),
      imagen: Value(imagen),
      habilitado: Value(habilitado),
      pendingSync: Value(pendingSync),
    );
  }

  factory DocumentoRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentoRow(
      id: serializer.fromJson<String>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      imagen: serializer.fromJson<String>(json['imagen']),
      habilitado: serializer.fromJson<bool>(json['habilitado']),
      pendingSync: serializer.fromJson<bool>(json['pendingSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombre': serializer.toJson<String>(nombre),
      'descripcion': serializer.toJson<String>(descripcion),
      'imagen': serializer.toJson<String>(imagen),
      'habilitado': serializer.toJson<bool>(habilitado),
      'pendingSync': serializer.toJson<bool>(pendingSync),
    };
  }

  DocumentoRow copyWith({
    String? id,
    String? nombre,
    String? descripcion,
    String? imagen,
    bool? habilitado,
    bool? pendingSync,
  }) => DocumentoRow(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    descripcion: descripcion ?? this.descripcion,
    imagen: imagen ?? this.imagen,
    habilitado: habilitado ?? this.habilitado,
    pendingSync: pendingSync ?? this.pendingSync,
  );
  DocumentoRow copyWithCompanion(DocumentosCompanion data) {
    return DocumentoRow(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      descripcion: data.descripcion.present
          ? data.descripcion.value
          : this.descripcion,
      imagen: data.imagen.present ? data.imagen.value : this.imagen,
      habilitado: data.habilitado.present
          ? data.habilitado.value
          : this.habilitado,
      pendingSync: data.pendingSync.present
          ? data.pendingSync.value
          : this.pendingSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentoRow(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('imagen: $imagen, ')
          ..write('habilitado: $habilitado, ')
          ..write('pendingSync: $pendingSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nombre, descripcion, imagen, habilitado, pendingSync);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentoRow &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.descripcion == this.descripcion &&
          other.imagen == this.imagen &&
          other.habilitado == this.habilitado &&
          other.pendingSync == this.pendingSync);
}

class DocumentosCompanion extends UpdateCompanion<DocumentoRow> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<String> descripcion;
  final Value<String> imagen;
  final Value<bool> habilitado;
  final Value<bool> pendingSync;
  final Value<int> rowid;
  const DocumentosCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.imagen = const Value.absent(),
    this.habilitado = const Value.absent(),
    this.pendingSync = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DocumentosCompanion.insert({
    required String id,
    required String nombre,
    required String descripcion,
    this.imagen = const Value.absent(),
    this.habilitado = const Value.absent(),
    this.pendingSync = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nombre = Value(nombre),
       descripcion = Value(descripcion);
  static Insertable<DocumentoRow> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<String>? descripcion,
    Expression<String>? imagen,
    Expression<bool>? habilitado,
    Expression<bool>? pendingSync,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (descripcion != null) 'descripcion': descripcion,
      if (imagen != null) 'imagen': imagen,
      if (habilitado != null) 'habilitado': habilitado,
      if (pendingSync != null) 'pending_sync': pendingSync,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DocumentosCompanion copyWith({
    Value<String>? id,
    Value<String>? nombre,
    Value<String>? descripcion,
    Value<String>? imagen,
    Value<bool>? habilitado,
    Value<bool>? pendingSync,
    Value<int>? rowid,
  }) {
    return DocumentosCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      imagen: imagen ?? this.imagen,
      habilitado: habilitado ?? this.habilitado,
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
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (imagen.present) {
      map['imagen'] = Variable<String>(imagen.value);
    }
    if (habilitado.present) {
      map['habilitado'] = Variable<bool>(habilitado.value);
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
    return (StringBuffer('DocumentosCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('imagen: $imagen, ')
          ..write('habilitado: $habilitado, ')
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
  late final $MotivosTable motivos = $MotivosTable(this);
  late final $DocumentosTable documentos = $DocumentosTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    solicitudes,
    motivos,
    documentos,
  ];
}

typedef $$SolicitudesTableCreateCompanionBuilder =
    SolicitudesCompanion Function({
      required String id,
      required String idDocumento,
      required String idUsuario,
      required String periodo,
      Value<String> observacionEstudiante,
      required String estado,
      required DateTime fechaCreacion,
      required DateTime fechaModificacion,
      Value<String?> observacionRevision,
      Value<DateTime?> fechaEntrega,
      Value<String?> entregadoPor,
      Value<bool> pendingSync,
      Value<int> rowid,
    });
typedef $$SolicitudesTableUpdateCompanionBuilder =
    SolicitudesCompanion Function({
      Value<String> id,
      Value<String> idDocumento,
      Value<String> idUsuario,
      Value<String> periodo,
      Value<String> observacionEstudiante,
      Value<String> estado,
      Value<DateTime> fechaCreacion,
      Value<DateTime> fechaModificacion,
      Value<String?> observacionRevision,
      Value<DateTime?> fechaEntrega,
      Value<String?> entregadoPor,
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

  ColumnFilters<String> get observacionEstudiante => $composableBuilder(
    column: $table.observacionEstudiante,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaModificacion => $composableBuilder(
    column: $table.fechaModificacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observacionRevision => $composableBuilder(
    column: $table.observacionRevision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaEntrega => $composableBuilder(
    column: $table.fechaEntrega,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entregadoPor => $composableBuilder(
    column: $table.entregadoPor,
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

  ColumnOrderings<String> get observacionEstudiante => $composableBuilder(
    column: $table.observacionEstudiante,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaModificacion => $composableBuilder(
    column: $table.fechaModificacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observacionRevision => $composableBuilder(
    column: $table.observacionRevision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaEntrega => $composableBuilder(
    column: $table.fechaEntrega,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entregadoPor => $composableBuilder(
    column: $table.entregadoPor,
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

  GeneratedColumn<String> get observacionEstudiante => $composableBuilder(
    column: $table.observacionEstudiante,
    builder: (column) => column,
  );

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaModificacion => $composableBuilder(
    column: $table.fechaModificacion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get observacionRevision => $composableBuilder(
    column: $table.observacionRevision,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaEntrega => $composableBuilder(
    column: $table.fechaEntrega,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entregadoPor => $composableBuilder(
    column: $table.entregadoPor,
    builder: (column) => column,
  );

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
                Value<String> observacionEstudiante = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<DateTime> fechaCreacion = const Value.absent(),
                Value<DateTime> fechaModificacion = const Value.absent(),
                Value<String?> observacionRevision = const Value.absent(),
                Value<DateTime?> fechaEntrega = const Value.absent(),
                Value<String?> entregadoPor = const Value.absent(),
                Value<bool> pendingSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SolicitudesCompanion(
                id: id,
                idDocumento: idDocumento,
                idUsuario: idUsuario,
                periodo: periodo,
                observacionEstudiante: observacionEstudiante,
                estado: estado,
                fechaCreacion: fechaCreacion,
                fechaModificacion: fechaModificacion,
                observacionRevision: observacionRevision,
                fechaEntrega: fechaEntrega,
                entregadoPor: entregadoPor,
                pendingSync: pendingSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String idDocumento,
                required String idUsuario,
                required String periodo,
                Value<String> observacionEstudiante = const Value.absent(),
                required String estado,
                required DateTime fechaCreacion,
                required DateTime fechaModificacion,
                Value<String?> observacionRevision = const Value.absent(),
                Value<DateTime?> fechaEntrega = const Value.absent(),
                Value<String?> entregadoPor = const Value.absent(),
                Value<bool> pendingSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SolicitudesCompanion.insert(
                id: id,
                idDocumento: idDocumento,
                idUsuario: idUsuario,
                periodo: periodo,
                observacionEstudiante: observacionEstudiante,
                estado: estado,
                fechaCreacion: fechaCreacion,
                fechaModificacion: fechaModificacion,
                observacionRevision: observacionRevision,
                fechaEntrega: fechaEntrega,
                entregadoPor: entregadoPor,
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
typedef $$MotivosTableCreateCompanionBuilder = MotivosCompanion Function({
  required String id,
  required String idSolicitud,
  required String mensaje,
  required String estado,
  required DateTime fechaCreacion,
  Value<bool> pendingSync,
  Value<int> rowid,
});
typedef $$MotivosTableUpdateCompanionBuilder = MotivosCompanion Function({
  Value<String> id,
  Value<String> idSolicitud,
  Value<String> mensaje,
  Value<String> estado,
  Value<DateTime> fechaCreacion,
  Value<bool> pendingSync,
  Value<int> rowid,
});

class $$MotivosTableFilterComposer
    extends Composer<_$AppDatabase, $MotivosTable> {
  $$MotivosTableFilterComposer({
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

  ColumnFilters<String> get idSolicitud => $composableBuilder(
    column: $table.idSolicitud,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mensaje => $composableBuilder(
    column: $table.mensaje,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pendingSync => $composableBuilder(
    column: $table.pendingSync,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MotivosTableOrderingComposer
    extends Composer<_$AppDatabase, $MotivosTable> {
  $$MotivosTableOrderingComposer({
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

  ColumnOrderings<String> get idSolicitud => $composableBuilder(
    column: $table.idSolicitud,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mensaje => $composableBuilder(
    column: $table.mensaje,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pendingSync => $composableBuilder(
    column: $table.pendingSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MotivosTableAnnotationComposer
    extends Composer<_$AppDatabase, $MotivosTable> {
  $$MotivosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get idSolicitud => $composableBuilder(
    column: $table.idSolicitud,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mensaje =>
      $composableBuilder(column: $table.mensaje, builder: (column) => column);

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaCreacion => $composableBuilder(
    column: $table.fechaCreacion,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get pendingSync => $composableBuilder(
    column: $table.pendingSync,
    builder: (column) => column,
  );
}

class $$MotivosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MotivosTable,
          MotivoRow,
          $$MotivosTableFilterComposer,
          $$MotivosTableOrderingComposer,
          $$MotivosTableAnnotationComposer,
          $$MotivosTableCreateCompanionBuilder,
          $$MotivosTableUpdateCompanionBuilder,
          (MotivoRow, BaseReferences<_$AppDatabase, $MotivosTable, MotivoRow>),
          MotivoRow,
          PrefetchHooks Function()
        > {
  $$MotivosTableTableManager(_$AppDatabase db, $MotivosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MotivosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MotivosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MotivosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> idSolicitud = const Value.absent(),
                Value<String> mensaje = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<DateTime> fechaCreacion = const Value.absent(),
                Value<bool> pendingSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MotivosCompanion(
                id: id,
                idSolicitud: idSolicitud,
                mensaje: mensaje,
                estado: estado,
                fechaCreacion: fechaCreacion,
                pendingSync: pendingSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String idSolicitud,
                required String mensaje,
                required String estado,
                required DateTime fechaCreacion,
                Value<bool> pendingSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MotivosCompanion.insert(
                id: id,
                idSolicitud: idSolicitud,
                mensaje: mensaje,
                estado: estado,
                fechaCreacion: fechaCreacion,
                pendingSync: pendingSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MotivosTable, MotivoRow>(table),
                  BaseReferences<_$AppDatabase, $MotivosTable, MotivoRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MotivosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MotivosTable,
      MotivoRow,
      $$MotivosTableFilterComposer,
      $$MotivosTableOrderingComposer,
      $$MotivosTableAnnotationComposer,
      $$MotivosTableCreateCompanionBuilder,
      $$MotivosTableUpdateCompanionBuilder,
      (MotivoRow, BaseReferences<_$AppDatabase, $MotivosTable, MotivoRow>),
      MotivoRow,
      PrefetchHooks Function()
    >;
typedef $$DocumentosTableCreateCompanionBuilder = DocumentosCompanion Function({
  required String id,
  required String nombre,
  required String descripcion,
  Value<String> imagen,
  Value<bool> habilitado,
  Value<bool> pendingSync,
  Value<int> rowid,
});
typedef $$DocumentosTableUpdateCompanionBuilder = DocumentosCompanion Function({
  Value<String> id,
  Value<String> nombre,
  Value<String> descripcion,
  Value<String> imagen,
  Value<bool> habilitado,
  Value<bool> pendingSync,
  Value<int> rowid,
});

class $$DocumentosTableFilterComposer
    extends Composer<_$AppDatabase, $DocumentosTable> {
  $$DocumentosTableFilterComposer({
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

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagen => $composableBuilder(
    column: $table.imagen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get habilitado => $composableBuilder(
    column: $table.habilitado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pendingSync => $composableBuilder(
    column: $table.pendingSync,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DocumentosTableOrderingComposer
    extends Composer<_$AppDatabase, $DocumentosTable> {
  $$DocumentosTableOrderingComposer({
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

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagen => $composableBuilder(
    column: $table.imagen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get habilitado => $composableBuilder(
    column: $table.habilitado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pendingSync => $composableBuilder(
    column: $table.pendingSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DocumentosTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocumentosTable> {
  $$DocumentosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imagen =>
      $composableBuilder(column: $table.imagen, builder: (column) => column);

  GeneratedColumn<bool> get habilitado => $composableBuilder(
    column: $table.habilitado,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get pendingSync => $composableBuilder(
    column: $table.pendingSync,
    builder: (column) => column,
  );
}

class $$DocumentosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DocumentosTable,
          DocumentoRow,
          $$DocumentosTableFilterComposer,
          $$DocumentosTableOrderingComposer,
          $$DocumentosTableAnnotationComposer,
          $$DocumentosTableCreateCompanionBuilder,
          $$DocumentosTableUpdateCompanionBuilder,
          (
            DocumentoRow,
            BaseReferences<_$AppDatabase, $DocumentosTable, DocumentoRow>,
          ),
          DocumentoRow,
          PrefetchHooks Function()
        > {
  $$DocumentosTableTableManager(_$AppDatabase db, $DocumentosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> descripcion = const Value.absent(),
                Value<String> imagen = const Value.absent(),
                Value<bool> habilitado = const Value.absent(),
                Value<bool> pendingSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DocumentosCompanion(
                id: id,
                nombre: nombre,
                descripcion: descripcion,
                imagen: imagen,
                habilitado: habilitado,
                pendingSync: pendingSync,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nombre,
                required String descripcion,
                Value<String> imagen = const Value.absent(),
                Value<bool> habilitado = const Value.absent(),
                Value<bool> pendingSync = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DocumentosCompanion.insert(
                id: id,
                nombre: nombre,
                descripcion: descripcion,
                imagen: imagen,
                habilitado: habilitado,
                pendingSync: pendingSync,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DocumentosTable, DocumentoRow>(table),
                  BaseReferences<_$AppDatabase, $DocumentosTable, DocumentoRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DocumentosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DocumentosTable,
      DocumentoRow,
      $$DocumentosTableFilterComposer,
      $$DocumentosTableOrderingComposer,
      $$DocumentosTableAnnotationComposer,
      $$DocumentosTableCreateCompanionBuilder,
      $$DocumentosTableUpdateCompanionBuilder,
      (
        DocumentoRow,
        BaseReferences<_$AppDatabase, $DocumentosTable, DocumentoRow>,
      ),
      DocumentoRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SolicitudesTableTableManager get solicitudes =>
      $$SolicitudesTableTableManager(_db, _db.solicitudes);
  $$MotivosTableTableManager get motivos =>
      $$MotivosTableTableManager(_db, _db.motivos);
  $$DocumentosTableTableManager get documentos =>
      $$DocumentosTableTableManager(_db, _db.documentos);
}
