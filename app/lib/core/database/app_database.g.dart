// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CreatureStatesTable extends CreatureStates
    with TableInfo<$CreatureStatesTable, CreatureState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CreatureStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _foodMeta = const VerificationMeta('food');
  @override
  late final GeneratedColumn<int> food = GeneratedColumn<int>(
    'food',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _traitPointsMeta = const VerificationMeta(
    'traitPoints',
  );
  @override
  late final GeneratedColumn<String> traitPoints = GeneratedColumn<String>(
    'trait_points',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _lastFedAtMeta = const VerificationMeta(
    'lastFedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastFedAt = GeneratedColumn<DateTime>(
    'last_fed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, food, traitPoints, lastFedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'creature_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<CreatureState> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('food')) {
      context.handle(
        _foodMeta,
        food.isAcceptableOrUnknown(data['food']!, _foodMeta),
      );
    }
    if (data.containsKey('trait_points')) {
      context.handle(
        _traitPointsMeta,
        traitPoints.isAcceptableOrUnknown(
          data['trait_points']!,
          _traitPointsMeta,
        ),
      );
    }
    if (data.containsKey('last_fed_at')) {
      context.handle(
        _lastFedAtMeta,
        lastFedAt.isAcceptableOrUnknown(data['last_fed_at']!, _lastFedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CreatureState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CreatureState(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      food: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}food'],
      )!,
      traitPoints: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trait_points'],
      )!,
      lastFedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_fed_at'],
      ),
    );
  }

  @override
  $CreatureStatesTable createAlias(String alias) {
    return $CreatureStatesTable(attachedDatabase, alias);
  }
}

class CreatureState extends DataClass implements Insertable<CreatureState> {
  final int id;
  final int food;

  /// Merkmalspunkte als JSON, z. B. `{"moss":3}`.
  final String traitPoints;
  final DateTime? lastFedAt;
  const CreatureState({
    required this.id,
    required this.food,
    required this.traitPoints,
    this.lastFedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['food'] = Variable<int>(food);
    map['trait_points'] = Variable<String>(traitPoints);
    if (!nullToAbsent || lastFedAt != null) {
      map['last_fed_at'] = Variable<DateTime>(lastFedAt);
    }
    return map;
  }

  CreatureStatesCompanion toCompanion(bool nullToAbsent) {
    return CreatureStatesCompanion(
      id: Value(id),
      food: Value(food),
      traitPoints: Value(traitPoints),
      lastFedAt: lastFedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastFedAt),
    );
  }

  factory CreatureState.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CreatureState(
      id: serializer.fromJson<int>(json['id']),
      food: serializer.fromJson<int>(json['food']),
      traitPoints: serializer.fromJson<String>(json['traitPoints']),
      lastFedAt: serializer.fromJson<DateTime?>(json['lastFedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'food': serializer.toJson<int>(food),
      'traitPoints': serializer.toJson<String>(traitPoints),
      'lastFedAt': serializer.toJson<DateTime?>(lastFedAt),
    };
  }

  CreatureState copyWith({
    int? id,
    int? food,
    String? traitPoints,
    Value<DateTime?> lastFedAt = const Value.absent(),
  }) => CreatureState(
    id: id ?? this.id,
    food: food ?? this.food,
    traitPoints: traitPoints ?? this.traitPoints,
    lastFedAt: lastFedAt.present ? lastFedAt.value : this.lastFedAt,
  );
  CreatureState copyWithCompanion(CreatureStatesCompanion data) {
    return CreatureState(
      id: data.id.present ? data.id.value : this.id,
      food: data.food.present ? data.food.value : this.food,
      traitPoints: data.traitPoints.present
          ? data.traitPoints.value
          : this.traitPoints,
      lastFedAt: data.lastFedAt.present ? data.lastFedAt.value : this.lastFedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CreatureState(')
          ..write('id: $id, ')
          ..write('food: $food, ')
          ..write('traitPoints: $traitPoints, ')
          ..write('lastFedAt: $lastFedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, food, traitPoints, lastFedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CreatureState &&
          other.id == this.id &&
          other.food == this.food &&
          other.traitPoints == this.traitPoints &&
          other.lastFedAt == this.lastFedAt);
}

class CreatureStatesCompanion extends UpdateCompanion<CreatureState> {
  final Value<int> id;
  final Value<int> food;
  final Value<String> traitPoints;
  final Value<DateTime?> lastFedAt;
  const CreatureStatesCompanion({
    this.id = const Value.absent(),
    this.food = const Value.absent(),
    this.traitPoints = const Value.absent(),
    this.lastFedAt = const Value.absent(),
  });
  CreatureStatesCompanion.insert({
    this.id = const Value.absent(),
    this.food = const Value.absent(),
    this.traitPoints = const Value.absent(),
    this.lastFedAt = const Value.absent(),
  });
  static Insertable<CreatureState> custom({
    Expression<int>? id,
    Expression<int>? food,
    Expression<String>? traitPoints,
    Expression<DateTime>? lastFedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (food != null) 'food': food,
      if (traitPoints != null) 'trait_points': traitPoints,
      if (lastFedAt != null) 'last_fed_at': lastFedAt,
    });
  }

  CreatureStatesCompanion copyWith({
    Value<int>? id,
    Value<int>? food,
    Value<String>? traitPoints,
    Value<DateTime?>? lastFedAt,
  }) {
    return CreatureStatesCompanion(
      id: id ?? this.id,
      food: food ?? this.food,
      traitPoints: traitPoints ?? this.traitPoints,
      lastFedAt: lastFedAt ?? this.lastFedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (food.present) {
      map['food'] = Variable<int>(food.value);
    }
    if (traitPoints.present) {
      map['trait_points'] = Variable<String>(traitPoints.value);
    }
    if (lastFedAt.present) {
      map['last_fed_at'] = Variable<DateTime>(lastFedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CreatureStatesCompanion(')
          ..write('id: $id, ')
          ..write('food: $food, ')
          ..write('traitPoints: $traitPoints, ')
          ..write('lastFedAt: $lastFedAt')
          ..write(')'))
        .toString();
  }
}

class $KnownSegmentsTable extends KnownSegments
    with TableInfo<$KnownSegmentsTable, KnownSegment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KnownSegmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _segmentIdMeta = const VerificationMeta(
    'segmentId',
  );
  @override
  late final GeneratedColumn<String> segmentId = GeneratedColumn<String>(
    'segment_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _discoveredAtMeta = const VerificationMeta(
    'discoveredAt',
  );
  @override
  late final GeneratedColumn<DateTime> discoveredAt = GeneratedColumn<DateTime>(
    'discovered_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [segmentId, discoveredAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'known_segments';
  @override
  VerificationContext validateIntegrity(
    Insertable<KnownSegment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('segment_id')) {
      context.handle(
        _segmentIdMeta,
        segmentId.isAcceptableOrUnknown(data['segment_id']!, _segmentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_segmentIdMeta);
    }
    if (data.containsKey('discovered_at')) {
      context.handle(
        _discoveredAtMeta,
        discoveredAt.isAcceptableOrUnknown(
          data['discovered_at']!,
          _discoveredAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_discoveredAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {segmentId};
  @override
  KnownSegment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KnownSegment(
      segmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}segment_id'],
      )!,
      discoveredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}discovered_at'],
      )!,
    );
  }

  @override
  $KnownSegmentsTable createAlias(String alias) {
    return $KnownSegmentsTable(attachedDatabase, alias);
  }
}

class KnownSegment extends DataClass implements Insertable<KnownSegment> {
  final String segmentId;
  final DateTime discoveredAt;
  const KnownSegment({required this.segmentId, required this.discoveredAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['segment_id'] = Variable<String>(segmentId);
    map['discovered_at'] = Variable<DateTime>(discoveredAt);
    return map;
  }

  KnownSegmentsCompanion toCompanion(bool nullToAbsent) {
    return KnownSegmentsCompanion(
      segmentId: Value(segmentId),
      discoveredAt: Value(discoveredAt),
    );
  }

  factory KnownSegment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KnownSegment(
      segmentId: serializer.fromJson<String>(json['segmentId']),
      discoveredAt: serializer.fromJson<DateTime>(json['discoveredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'segmentId': serializer.toJson<String>(segmentId),
      'discoveredAt': serializer.toJson<DateTime>(discoveredAt),
    };
  }

  KnownSegment copyWith({String? segmentId, DateTime? discoveredAt}) =>
      KnownSegment(
        segmentId: segmentId ?? this.segmentId,
        discoveredAt: discoveredAt ?? this.discoveredAt,
      );
  KnownSegment copyWithCompanion(KnownSegmentsCompanion data) {
    return KnownSegment(
      segmentId: data.segmentId.present ? data.segmentId.value : this.segmentId,
      discoveredAt: data.discoveredAt.present
          ? data.discoveredAt.value
          : this.discoveredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KnownSegment(')
          ..write('segmentId: $segmentId, ')
          ..write('discoveredAt: $discoveredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(segmentId, discoveredAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KnownSegment &&
          other.segmentId == this.segmentId &&
          other.discoveredAt == this.discoveredAt);
}

class KnownSegmentsCompanion extends UpdateCompanion<KnownSegment> {
  final Value<String> segmentId;
  final Value<DateTime> discoveredAt;
  final Value<int> rowid;
  const KnownSegmentsCompanion({
    this.segmentId = const Value.absent(),
    this.discoveredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KnownSegmentsCompanion.insert({
    required String segmentId,
    required DateTime discoveredAt,
    this.rowid = const Value.absent(),
  }) : segmentId = Value(segmentId),
       discoveredAt = Value(discoveredAt);
  static Insertable<KnownSegment> custom({
    Expression<String>? segmentId,
    Expression<DateTime>? discoveredAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (segmentId != null) 'segment_id': segmentId,
      if (discoveredAt != null) 'discovered_at': discoveredAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KnownSegmentsCompanion copyWith({
    Value<String>? segmentId,
    Value<DateTime>? discoveredAt,
    Value<int>? rowid,
  }) {
    return KnownSegmentsCompanion(
      segmentId: segmentId ?? this.segmentId,
      discoveredAt: discoveredAt ?? this.discoveredAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (segmentId.present) {
      map['segment_id'] = Variable<String>(segmentId.value);
    }
    if (discoveredAt.present) {
      map['discovered_at'] = Variable<DateTime>(discoveredAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KnownSegmentsCompanion(')
          ..write('segmentId: $segmentId, ')
          ..write('discoveredAt: $discoveredAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecordedWalksTable extends RecordedWalks
    with TableInfo<$RecordedWalksTable, RecordedWalk> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecordedWalksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gpxMeta = const VerificationMeta('gpx');
  @override
  late final GeneratedColumn<String> gpx = GeneratedColumn<String>(
    'gpx',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _processedAtMeta = const VerificationMeta(
    'processedAt',
  );
  @override
  late final GeneratedColumn<DateTime> processedAt = GeneratedColumn<DateTime>(
    'processed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, startedAt, gpx, processedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recorded_walks';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecordedWalk> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('gpx')) {
      context.handle(
        _gpxMeta,
        gpx.isAcceptableOrUnknown(data['gpx']!, _gpxMeta),
      );
    } else if (isInserting) {
      context.missing(_gpxMeta);
    }
    if (data.containsKey('processed_at')) {
      context.handle(
        _processedAtMeta,
        processedAt.isAcceptableOrUnknown(
          data['processed_at']!,
          _processedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecordedWalk map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecordedWalk(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      gpx: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gpx'],
      )!,
      processedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}processed_at'],
      ),
    );
  }

  @override
  $RecordedWalksTable createAlias(String alias) {
    return $RecordedWalksTable(attachedDatabase, alias);
  }
}

class RecordedWalk extends DataClass implements Insertable<RecordedWalk> {
  final String id;
  final DateTime startedAt;
  final String gpx;
  final DateTime? processedAt;
  const RecordedWalk({
    required this.id,
    required this.startedAt,
    required this.gpx,
    this.processedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['gpx'] = Variable<String>(gpx);
    if (!nullToAbsent || processedAt != null) {
      map['processed_at'] = Variable<DateTime>(processedAt);
    }
    return map;
  }

  RecordedWalksCompanion toCompanion(bool nullToAbsent) {
    return RecordedWalksCompanion(
      id: Value(id),
      startedAt: Value(startedAt),
      gpx: Value(gpx),
      processedAt: processedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(processedAt),
    );
  }

  factory RecordedWalk.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecordedWalk(
      id: serializer.fromJson<String>(json['id']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      gpx: serializer.fromJson<String>(json['gpx']),
      processedAt: serializer.fromJson<DateTime?>(json['processedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'gpx': serializer.toJson<String>(gpx),
      'processedAt': serializer.toJson<DateTime?>(processedAt),
    };
  }

  RecordedWalk copyWith({
    String? id,
    DateTime? startedAt,
    String? gpx,
    Value<DateTime?> processedAt = const Value.absent(),
  }) => RecordedWalk(
    id: id ?? this.id,
    startedAt: startedAt ?? this.startedAt,
    gpx: gpx ?? this.gpx,
    processedAt: processedAt.present ? processedAt.value : this.processedAt,
  );
  RecordedWalk copyWithCompanion(RecordedWalksCompanion data) {
    return RecordedWalk(
      id: data.id.present ? data.id.value : this.id,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      gpx: data.gpx.present ? data.gpx.value : this.gpx,
      processedAt: data.processedAt.present
          ? data.processedAt.value
          : this.processedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecordedWalk(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('gpx: $gpx, ')
          ..write('processedAt: $processedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, startedAt, gpx, processedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecordedWalk &&
          other.id == this.id &&
          other.startedAt == this.startedAt &&
          other.gpx == this.gpx &&
          other.processedAt == this.processedAt);
}

class RecordedWalksCompanion extends UpdateCompanion<RecordedWalk> {
  final Value<String> id;
  final Value<DateTime> startedAt;
  final Value<String> gpx;
  final Value<DateTime?> processedAt;
  final Value<int> rowid;
  const RecordedWalksCompanion({
    this.id = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.gpx = const Value.absent(),
    this.processedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecordedWalksCompanion.insert({
    required String id,
    required DateTime startedAt,
    required String gpx,
    this.processedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       startedAt = Value(startedAt),
       gpx = Value(gpx);
  static Insertable<RecordedWalk> custom({
    Expression<String>? id,
    Expression<DateTime>? startedAt,
    Expression<String>? gpx,
    Expression<DateTime>? processedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startedAt != null) 'started_at': startedAt,
      if (gpx != null) 'gpx': gpx,
      if (processedAt != null) 'processed_at': processedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecordedWalksCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? startedAt,
    Value<String>? gpx,
    Value<DateTime?>? processedAt,
    Value<int>? rowid,
  }) {
    return RecordedWalksCompanion(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      gpx: gpx ?? this.gpx,
      processedAt: processedAt ?? this.processedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (gpx.present) {
      map['gpx'] = Variable<String>(gpx.value);
    }
    if (processedAt.present) {
      map['processed_at'] = Variable<DateTime>(processedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecordedWalksCompanion(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('gpx: $gpx, ')
          ..write('processedAt: $processedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CreatureStatesTable creatureStates = $CreatureStatesTable(this);
  late final $KnownSegmentsTable knownSegments = $KnownSegmentsTable(this);
  late final $RecordedWalksTable recordedWalks = $RecordedWalksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    creatureStates,
    knownSegments,
    recordedWalks,
  ];
}

typedef $$CreatureStatesTableCreateCompanionBuilder =
    CreatureStatesCompanion Function({
      Value<int> id,
      Value<int> food,
      Value<String> traitPoints,
      Value<DateTime?> lastFedAt,
    });
typedef $$CreatureStatesTableUpdateCompanionBuilder =
    CreatureStatesCompanion Function({
      Value<int> id,
      Value<int> food,
      Value<String> traitPoints,
      Value<DateTime?> lastFedAt,
    });

class $$CreatureStatesTableFilterComposer
    extends Composer<_$AppDatabase, $CreatureStatesTable> {
  $$CreatureStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get food => $composableBuilder(
    column: $table.food,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get traitPoints => $composableBuilder(
    column: $table.traitPoints,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastFedAt => $composableBuilder(
    column: $table.lastFedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CreatureStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $CreatureStatesTable> {
  $$CreatureStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get food => $composableBuilder(
    column: $table.food,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get traitPoints => $composableBuilder(
    column: $table.traitPoints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastFedAt => $composableBuilder(
    column: $table.lastFedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CreatureStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CreatureStatesTable> {
  $$CreatureStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get food =>
      $composableBuilder(column: $table.food, builder: (column) => column);

  GeneratedColumn<String> get traitPoints => $composableBuilder(
    column: $table.traitPoints,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastFedAt =>
      $composableBuilder(column: $table.lastFedAt, builder: (column) => column);
}

class $$CreatureStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CreatureStatesTable,
          CreatureState,
          $$CreatureStatesTableFilterComposer,
          $$CreatureStatesTableOrderingComposer,
          $$CreatureStatesTableAnnotationComposer,
          $$CreatureStatesTableCreateCompanionBuilder,
          $$CreatureStatesTableUpdateCompanionBuilder,
          (
            CreatureState,
            BaseReferences<_$AppDatabase, $CreatureStatesTable, CreatureState>,
          ),
          CreatureState,
          PrefetchHooks Function()
        > {
  $$CreatureStatesTableTableManager(
    _$AppDatabase db,
    $CreatureStatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CreatureStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CreatureStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CreatureStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> food = const Value.absent(),
                Value<String> traitPoints = const Value.absent(),
                Value<DateTime?> lastFedAt = const Value.absent(),
              }) => CreatureStatesCompanion(
                id: id,
                food: food,
                traitPoints: traitPoints,
                lastFedAt: lastFedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> food = const Value.absent(),
                Value<String> traitPoints = const Value.absent(),
                Value<DateTime?> lastFedAt = const Value.absent(),
              }) => CreatureStatesCompanion.insert(
                id: id,
                food: food,
                traitPoints: traitPoints,
                lastFedAt: lastFedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CreatureStatesTable, CreatureState>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CreatureStatesTable,
                    CreatureState
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CreatureStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CreatureStatesTable,
      CreatureState,
      $$CreatureStatesTableFilterComposer,
      $$CreatureStatesTableOrderingComposer,
      $$CreatureStatesTableAnnotationComposer,
      $$CreatureStatesTableCreateCompanionBuilder,
      $$CreatureStatesTableUpdateCompanionBuilder,
      (
        CreatureState,
        BaseReferences<_$AppDatabase, $CreatureStatesTable, CreatureState>,
      ),
      CreatureState,
      PrefetchHooks Function()
    >;
typedef $$KnownSegmentsTableCreateCompanionBuilder =
    KnownSegmentsCompanion Function({
      required String segmentId,
      required DateTime discoveredAt,
      Value<int> rowid,
    });
typedef $$KnownSegmentsTableUpdateCompanionBuilder =
    KnownSegmentsCompanion Function({
      Value<String> segmentId,
      Value<DateTime> discoveredAt,
      Value<int> rowid,
    });

class $$KnownSegmentsTableFilterComposer
    extends Composer<_$AppDatabase, $KnownSegmentsTable> {
  $$KnownSegmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get segmentId => $composableBuilder(
    column: $table.segmentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get discoveredAt => $composableBuilder(
    column: $table.discoveredAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$KnownSegmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $KnownSegmentsTable> {
  $$KnownSegmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get segmentId => $composableBuilder(
    column: $table.segmentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get discoveredAt => $composableBuilder(
    column: $table.discoveredAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KnownSegmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $KnownSegmentsTable> {
  $$KnownSegmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get segmentId =>
      $composableBuilder(column: $table.segmentId, builder: (column) => column);

  GeneratedColumn<DateTime> get discoveredAt => $composableBuilder(
    column: $table.discoveredAt,
    builder: (column) => column,
  );
}

class $$KnownSegmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KnownSegmentsTable,
          KnownSegment,
          $$KnownSegmentsTableFilterComposer,
          $$KnownSegmentsTableOrderingComposer,
          $$KnownSegmentsTableAnnotationComposer,
          $$KnownSegmentsTableCreateCompanionBuilder,
          $$KnownSegmentsTableUpdateCompanionBuilder,
          (
            KnownSegment,
            BaseReferences<_$AppDatabase, $KnownSegmentsTable, KnownSegment>,
          ),
          KnownSegment,
          PrefetchHooks Function()
        > {
  $$KnownSegmentsTableTableManager(_$AppDatabase db, $KnownSegmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KnownSegmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KnownSegmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KnownSegmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> segmentId = const Value.absent(),
                Value<DateTime> discoveredAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KnownSegmentsCompanion(
                segmentId: segmentId,
                discoveredAt: discoveredAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String segmentId,
                required DateTime discoveredAt,
                Value<int> rowid = const Value.absent(),
              }) => KnownSegmentsCompanion.insert(
                segmentId: segmentId,
                discoveredAt: discoveredAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$KnownSegmentsTable, KnownSegment>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $KnownSegmentsTable,
                    KnownSegment
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$KnownSegmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KnownSegmentsTable,
      KnownSegment,
      $$KnownSegmentsTableFilterComposer,
      $$KnownSegmentsTableOrderingComposer,
      $$KnownSegmentsTableAnnotationComposer,
      $$KnownSegmentsTableCreateCompanionBuilder,
      $$KnownSegmentsTableUpdateCompanionBuilder,
      (
        KnownSegment,
        BaseReferences<_$AppDatabase, $KnownSegmentsTable, KnownSegment>,
      ),
      KnownSegment,
      PrefetchHooks Function()
    >;
typedef $$RecordedWalksTableCreateCompanionBuilder =
    RecordedWalksCompanion Function({
      required String id,
      required DateTime startedAt,
      required String gpx,
      Value<DateTime?> processedAt,
      Value<int> rowid,
    });
typedef $$RecordedWalksTableUpdateCompanionBuilder =
    RecordedWalksCompanion Function({
      Value<String> id,
      Value<DateTime> startedAt,
      Value<String> gpx,
      Value<DateTime?> processedAt,
      Value<int> rowid,
    });

class $$RecordedWalksTableFilterComposer
    extends Composer<_$AppDatabase, $RecordedWalksTable> {
  $$RecordedWalksTableFilterComposer({
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

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gpx => $composableBuilder(
    column: $table.gpx,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get processedAt => $composableBuilder(
    column: $table.processedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecordedWalksTableOrderingComposer
    extends Composer<_$AppDatabase, $RecordedWalksTable> {
  $$RecordedWalksTableOrderingComposer({
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

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gpx => $composableBuilder(
    column: $table.gpx,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get processedAt => $composableBuilder(
    column: $table.processedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecordedWalksTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecordedWalksTable> {
  $$RecordedWalksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<String> get gpx =>
      $composableBuilder(column: $table.gpx, builder: (column) => column);

  GeneratedColumn<DateTime> get processedAt => $composableBuilder(
    column: $table.processedAt,
    builder: (column) => column,
  );
}

class $$RecordedWalksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecordedWalksTable,
          RecordedWalk,
          $$RecordedWalksTableFilterComposer,
          $$RecordedWalksTableOrderingComposer,
          $$RecordedWalksTableAnnotationComposer,
          $$RecordedWalksTableCreateCompanionBuilder,
          $$RecordedWalksTableUpdateCompanionBuilder,
          (
            RecordedWalk,
            BaseReferences<_$AppDatabase, $RecordedWalksTable, RecordedWalk>,
          ),
          RecordedWalk,
          PrefetchHooks Function()
        > {
  $$RecordedWalksTableTableManager(_$AppDatabase db, $RecordedWalksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecordedWalksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecordedWalksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecordedWalksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<String> gpx = const Value.absent(),
                Value<DateTime?> processedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecordedWalksCompanion(
                id: id,
                startedAt: startedAt,
                gpx: gpx,
                processedAt: processedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime startedAt,
                required String gpx,
                Value<DateTime?> processedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecordedWalksCompanion.insert(
                id: id,
                startedAt: startedAt,
                gpx: gpx,
                processedAt: processedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecordedWalksTable, RecordedWalk>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $RecordedWalksTable,
                    RecordedWalk
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecordedWalksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecordedWalksTable,
      RecordedWalk,
      $$RecordedWalksTableFilterComposer,
      $$RecordedWalksTableOrderingComposer,
      $$RecordedWalksTableAnnotationComposer,
      $$RecordedWalksTableCreateCompanionBuilder,
      $$RecordedWalksTableUpdateCompanionBuilder,
      (
        RecordedWalk,
        BaseReferences<_$AppDatabase, $RecordedWalksTable, RecordedWalk>,
      ),
      RecordedWalk,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CreatureStatesTableTableManager get creatureStates =>
      $$CreatureStatesTableTableManager(_db, _db.creatureStates);
  $$KnownSegmentsTableTableManager get knownSegments =>
      $$KnownSegmentsTableTableManager(_db, _db.knownSegments);
  $$RecordedWalksTableTableManager get recordedWalks =>
      $$RecordedWalksTableTableManager(_db, _db.recordedWalks);
}
