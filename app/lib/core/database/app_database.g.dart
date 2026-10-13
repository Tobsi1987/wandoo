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
  static const VerificationMeta _speciesIdMeta = const VerificationMeta(
    'speciesId',
  );
  @override
  late final GeneratedColumn<String> speciesId = GeneratedColumn<String>(
    'species_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastReleasedAtMeta = const VerificationMeta(
    'lastReleasedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastReleasedAt =
      GeneratedColumn<DateTime>(
        'last_released_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    food,
    traitPoints,
    lastFedAt,
    speciesId,
    lastReleasedAt,
  ];
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
    if (data.containsKey('species_id')) {
      context.handle(
        _speciesIdMeta,
        speciesId.isAcceptableOrUnknown(data['species_id']!, _speciesIdMeta),
      );
    }
    if (data.containsKey('last_released_at')) {
      context.handle(
        _lastReleasedAtMeta,
        lastReleasedAt.isAcceptableOrUnknown(
          data['last_released_at']!,
          _lastReleasedAtMeta,
        ),
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
      speciesId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}species_id'],
      ),
      lastReleasedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_released_at'],
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

  /// `Species.id`, gezogen beim Schlüpfen (seit Schema 5).
  final String? speciesId;
  final DateTime? lastReleasedAt;
  const CreatureState({
    required this.id,
    required this.food,
    required this.traitPoints,
    this.lastFedAt,
    this.speciesId,
    this.lastReleasedAt,
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
    if (!nullToAbsent || speciesId != null) {
      map['species_id'] = Variable<String>(speciesId);
    }
    if (!nullToAbsent || lastReleasedAt != null) {
      map['last_released_at'] = Variable<DateTime>(lastReleasedAt);
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
      speciesId: speciesId == null && nullToAbsent
          ? const Value.absent()
          : Value(speciesId),
      lastReleasedAt: lastReleasedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReleasedAt),
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
      speciesId: serializer.fromJson<String?>(json['speciesId']),
      lastReleasedAt: serializer.fromJson<DateTime?>(json['lastReleasedAt']),
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
      'speciesId': serializer.toJson<String?>(speciesId),
      'lastReleasedAt': serializer.toJson<DateTime?>(lastReleasedAt),
    };
  }

  CreatureState copyWith({
    int? id,
    int? food,
    String? traitPoints,
    Value<DateTime?> lastFedAt = const Value.absent(),
    Value<String?> speciesId = const Value.absent(),
    Value<DateTime?> lastReleasedAt = const Value.absent(),
  }) => CreatureState(
    id: id ?? this.id,
    food: food ?? this.food,
    traitPoints: traitPoints ?? this.traitPoints,
    lastFedAt: lastFedAt.present ? lastFedAt.value : this.lastFedAt,
    speciesId: speciesId.present ? speciesId.value : this.speciesId,
    lastReleasedAt: lastReleasedAt.present
        ? lastReleasedAt.value
        : this.lastReleasedAt,
  );
  CreatureState copyWithCompanion(CreatureStatesCompanion data) {
    return CreatureState(
      id: data.id.present ? data.id.value : this.id,
      food: data.food.present ? data.food.value : this.food,
      traitPoints: data.traitPoints.present
          ? data.traitPoints.value
          : this.traitPoints,
      lastFedAt: data.lastFedAt.present ? data.lastFedAt.value : this.lastFedAt,
      speciesId: data.speciesId.present ? data.speciesId.value : this.speciesId,
      lastReleasedAt: data.lastReleasedAt.present
          ? data.lastReleasedAt.value
          : this.lastReleasedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CreatureState(')
          ..write('id: $id, ')
          ..write('food: $food, ')
          ..write('traitPoints: $traitPoints, ')
          ..write('lastFedAt: $lastFedAt, ')
          ..write('speciesId: $speciesId, ')
          ..write('lastReleasedAt: $lastReleasedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, food, traitPoints, lastFedAt, speciesId, lastReleasedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CreatureState &&
          other.id == this.id &&
          other.food == this.food &&
          other.traitPoints == this.traitPoints &&
          other.lastFedAt == this.lastFedAt &&
          other.speciesId == this.speciesId &&
          other.lastReleasedAt == this.lastReleasedAt);
}

class CreatureStatesCompanion extends UpdateCompanion<CreatureState> {
  final Value<int> id;
  final Value<int> food;
  final Value<String> traitPoints;
  final Value<DateTime?> lastFedAt;
  final Value<String?> speciesId;
  final Value<DateTime?> lastReleasedAt;
  const CreatureStatesCompanion({
    this.id = const Value.absent(),
    this.food = const Value.absent(),
    this.traitPoints = const Value.absent(),
    this.lastFedAt = const Value.absent(),
    this.speciesId = const Value.absent(),
    this.lastReleasedAt = const Value.absent(),
  });
  CreatureStatesCompanion.insert({
    this.id = const Value.absent(),
    this.food = const Value.absent(),
    this.traitPoints = const Value.absent(),
    this.lastFedAt = const Value.absent(),
    this.speciesId = const Value.absent(),
    this.lastReleasedAt = const Value.absent(),
  });
  static Insertable<CreatureState> custom({
    Expression<int>? id,
    Expression<int>? food,
    Expression<String>? traitPoints,
    Expression<DateTime>? lastFedAt,
    Expression<String>? speciesId,
    Expression<DateTime>? lastReleasedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (food != null) 'food': food,
      if (traitPoints != null) 'trait_points': traitPoints,
      if (lastFedAt != null) 'last_fed_at': lastFedAt,
      if (speciesId != null) 'species_id': speciesId,
      if (lastReleasedAt != null) 'last_released_at': lastReleasedAt,
    });
  }

  CreatureStatesCompanion copyWith({
    Value<int>? id,
    Value<int>? food,
    Value<String>? traitPoints,
    Value<DateTime?>? lastFedAt,
    Value<String?>? speciesId,
    Value<DateTime?>? lastReleasedAt,
  }) {
    return CreatureStatesCompanion(
      id: id ?? this.id,
      food: food ?? this.food,
      traitPoints: traitPoints ?? this.traitPoints,
      lastFedAt: lastFedAt ?? this.lastFedAt,
      speciesId: speciesId ?? this.speciesId,
      lastReleasedAt: lastReleasedAt ?? this.lastReleasedAt,
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
    if (speciesId.present) {
      map['species_id'] = Variable<String>(speciesId.value);
    }
    if (lastReleasedAt.present) {
      map['last_released_at'] = Variable<DateTime>(lastReleasedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CreatureStatesCompanion(')
          ..write('id: $id, ')
          ..write('food: $food, ')
          ..write('traitPoints: $traitPoints, ')
          ..write('lastFedAt: $lastFedAt, ')
          ..write('speciesId: $speciesId, ')
          ..write('lastReleasedAt: $lastReleasedAt')
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
  static const VerificationMeta _finishedMeta = const VerificationMeta(
    'finished',
  );
  @override
  late final GeneratedColumn<bool> finished = GeneratedColumn<bool>(
    'finished',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("finished" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startedAt,
    gpx,
    processedAt,
    finished,
  ];
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
    if (data.containsKey('finished')) {
      context.handle(
        _finishedMeta,
        finished.isAcceptableOrUnknown(data['finished']!, _finishedMeta),
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
      finished: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}finished'],
      )!,
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

  /// false, solange der Gang noch läuft und nur zwischengesichert ist.
  final bool finished;
  const RecordedWalk({
    required this.id,
    required this.startedAt,
    required this.gpx,
    this.processedAt,
    required this.finished,
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
    map['finished'] = Variable<bool>(finished);
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
      finished: Value(finished),
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
      finished: serializer.fromJson<bool>(json['finished']),
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
      'finished': serializer.toJson<bool>(finished),
    };
  }

  RecordedWalk copyWith({
    String? id,
    DateTime? startedAt,
    String? gpx,
    Value<DateTime?> processedAt = const Value.absent(),
    bool? finished,
  }) => RecordedWalk(
    id: id ?? this.id,
    startedAt: startedAt ?? this.startedAt,
    gpx: gpx ?? this.gpx,
    processedAt: processedAt.present ? processedAt.value : this.processedAt,
    finished: finished ?? this.finished,
  );
  RecordedWalk copyWithCompanion(RecordedWalksCompanion data) {
    return RecordedWalk(
      id: data.id.present ? data.id.value : this.id,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      gpx: data.gpx.present ? data.gpx.value : this.gpx,
      processedAt: data.processedAt.present
          ? data.processedAt.value
          : this.processedAt,
      finished: data.finished.present ? data.finished.value : this.finished,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecordedWalk(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('gpx: $gpx, ')
          ..write('processedAt: $processedAt, ')
          ..write('finished: $finished')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, startedAt, gpx, processedAt, finished);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecordedWalk &&
          other.id == this.id &&
          other.startedAt == this.startedAt &&
          other.gpx == this.gpx &&
          other.processedAt == this.processedAt &&
          other.finished == this.finished);
}

class RecordedWalksCompanion extends UpdateCompanion<RecordedWalk> {
  final Value<String> id;
  final Value<DateTime> startedAt;
  final Value<String> gpx;
  final Value<DateTime?> processedAt;
  final Value<bool> finished;
  final Value<int> rowid;
  const RecordedWalksCompanion({
    this.id = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.gpx = const Value.absent(),
    this.processedAt = const Value.absent(),
    this.finished = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecordedWalksCompanion.insert({
    required String id,
    required DateTime startedAt,
    required String gpx,
    this.processedAt = const Value.absent(),
    this.finished = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       startedAt = Value(startedAt),
       gpx = Value(gpx);
  static Insertable<RecordedWalk> custom({
    Expression<String>? id,
    Expression<DateTime>? startedAt,
    Expression<String>? gpx,
    Expression<DateTime>? processedAt,
    Expression<bool>? finished,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startedAt != null) 'started_at': startedAt,
      if (gpx != null) 'gpx': gpx,
      if (processedAt != null) 'processed_at': processedAt,
      if (finished != null) 'finished': finished,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecordedWalksCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? startedAt,
    Value<String>? gpx,
    Value<DateTime?>? processedAt,
    Value<bool>? finished,
    Value<int>? rowid,
  }) {
    return RecordedWalksCompanion(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      gpx: gpx ?? this.gpx,
      processedAt: processedAt ?? this.processedAt,
      finished: finished ?? this.finished,
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
    if (finished.present) {
      map['finished'] = Variable<bool>(finished.value);
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
          ..write('finished: $finished, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WalkSummariesTable extends WalkSummaries
    with TableInfo<$WalkSummariesTable, WalkSummaryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalkSummariesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _walkIdMeta = const VerificationMeta('walkId');
  @override
  late final GeneratedColumn<String> walkId = GeneratedColumn<String>(
    'walk_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _finishedAtMeta = const VerificationMeta(
    'finishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> finishedAt = GeneratedColumn<DateTime>(
    'finished_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _newSegmentCountMeta = const VerificationMeta(
    'newSegmentCount',
  );
  @override
  late final GeneratedColumn<int> newSegmentCount = GeneratedColumn<int>(
    'new_segment_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _newStreetCountMeta = const VerificationMeta(
    'newStreetCount',
  );
  @override
  late final GeneratedColumn<int> newStreetCount = GeneratedColumn<int>(
    'new_street_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bridgeCountMeta = const VerificationMeta(
    'bridgeCount',
  );
  @override
  late final GeneratedColumn<int> bridgeCount = GeneratedColumn<int>(
    'bridge_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _knownSegmentCountMeta = const VerificationMeta(
    'knownSegmentCount',
  );
  @override
  late final GeneratedColumn<int> knownSegmentCount = GeneratedColumn<int>(
    'known_segment_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _streetsByEnvironmentMeta =
      const VerificationMeta('streetsByEnvironment');
  @override
  late final GeneratedColumn<String> streetsByEnvironment =
      GeneratedColumn<String>(
        'streets_by_environment',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _creatureGrewMeta = const VerificationMeta(
    'creatureGrew',
  );
  @override
  late final GeneratedColumn<bool> creatureGrew = GeneratedColumn<bool>(
    'creature_grew',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("creature_grew" IN (0, 1))',
    ),
  );
  static const VerificationMeta _seenMeta = const VerificationMeta('seen');
  @override
  late final GeneratedColumn<bool> seen = GeneratedColumn<bool>(
    'seen',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("seen" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    walkId,
    finishedAt,
    newSegmentCount,
    newStreetCount,
    bridgeCount,
    knownSegmentCount,
    streetsByEnvironment,
    creatureGrew,
    seen,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'walk_summaries';
  @override
  VerificationContext validateIntegrity(
    Insertable<WalkSummaryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('walk_id')) {
      context.handle(
        _walkIdMeta,
        walkId.isAcceptableOrUnknown(data['walk_id']!, _walkIdMeta),
      );
    } else if (isInserting) {
      context.missing(_walkIdMeta);
    }
    if (data.containsKey('finished_at')) {
      context.handle(
        _finishedAtMeta,
        finishedAt.isAcceptableOrUnknown(data['finished_at']!, _finishedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_finishedAtMeta);
    }
    if (data.containsKey('new_segment_count')) {
      context.handle(
        _newSegmentCountMeta,
        newSegmentCount.isAcceptableOrUnknown(
          data['new_segment_count']!,
          _newSegmentCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_newSegmentCountMeta);
    }
    if (data.containsKey('new_street_count')) {
      context.handle(
        _newStreetCountMeta,
        newStreetCount.isAcceptableOrUnknown(
          data['new_street_count']!,
          _newStreetCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_newStreetCountMeta);
    }
    if (data.containsKey('bridge_count')) {
      context.handle(
        _bridgeCountMeta,
        bridgeCount.isAcceptableOrUnknown(
          data['bridge_count']!,
          _bridgeCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_bridgeCountMeta);
    }
    if (data.containsKey('known_segment_count')) {
      context.handle(
        _knownSegmentCountMeta,
        knownSegmentCount.isAcceptableOrUnknown(
          data['known_segment_count']!,
          _knownSegmentCountMeta,
        ),
      );
    }
    if (data.containsKey('streets_by_environment')) {
      context.handle(
        _streetsByEnvironmentMeta,
        streetsByEnvironment.isAcceptableOrUnknown(
          data['streets_by_environment']!,
          _streetsByEnvironmentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_streetsByEnvironmentMeta);
    }
    if (data.containsKey('creature_grew')) {
      context.handle(
        _creatureGrewMeta,
        creatureGrew.isAcceptableOrUnknown(
          data['creature_grew']!,
          _creatureGrewMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_creatureGrewMeta);
    }
    if (data.containsKey('seen')) {
      context.handle(
        _seenMeta,
        seen.isAcceptableOrUnknown(data['seen']!, _seenMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {walkId};
  @override
  WalkSummaryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WalkSummaryRow(
      walkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}walk_id'],
      )!,
      finishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}finished_at'],
      )!,
      newSegmentCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}new_segment_count'],
      )!,
      newStreetCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}new_street_count'],
      )!,
      bridgeCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bridge_count'],
      )!,
      knownSegmentCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}known_segment_count'],
      )!,
      streetsByEnvironment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}streets_by_environment'],
      )!,
      creatureGrew: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}creature_grew'],
      )!,
      seen: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}seen'],
      )!,
    );
  }

  @override
  $WalkSummariesTable createAlias(String alias) {
    return $WalkSummariesTable(attachedDatabase, alias);
  }
}

class WalkSummaryRow extends DataClass implements Insertable<WalkSummaryRow> {
  final String walkId;
  final DateTime finishedAt;
  final int newSegmentCount;
  final int newStreetCount;
  final int bridgeCount;

  /// Wieder abgelaufene bekannte Abschnitte (seit Schema 4).
  final int knownSegmentCount;

  /// Neue Straßen je Umgebung als JSON, z. B. `{"forest":2}`.
  final String streetsByEnvironment;
  final bool creatureGrew;
  final bool seen;
  const WalkSummaryRow({
    required this.walkId,
    required this.finishedAt,
    required this.newSegmentCount,
    required this.newStreetCount,
    required this.bridgeCount,
    required this.knownSegmentCount,
    required this.streetsByEnvironment,
    required this.creatureGrew,
    required this.seen,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['walk_id'] = Variable<String>(walkId);
    map['finished_at'] = Variable<DateTime>(finishedAt);
    map['new_segment_count'] = Variable<int>(newSegmentCount);
    map['new_street_count'] = Variable<int>(newStreetCount);
    map['bridge_count'] = Variable<int>(bridgeCount);
    map['known_segment_count'] = Variable<int>(knownSegmentCount);
    map['streets_by_environment'] = Variable<String>(streetsByEnvironment);
    map['creature_grew'] = Variable<bool>(creatureGrew);
    map['seen'] = Variable<bool>(seen);
    return map;
  }

  WalkSummariesCompanion toCompanion(bool nullToAbsent) {
    return WalkSummariesCompanion(
      walkId: Value(walkId),
      finishedAt: Value(finishedAt),
      newSegmentCount: Value(newSegmentCount),
      newStreetCount: Value(newStreetCount),
      bridgeCount: Value(bridgeCount),
      knownSegmentCount: Value(knownSegmentCount),
      streetsByEnvironment: Value(streetsByEnvironment),
      creatureGrew: Value(creatureGrew),
      seen: Value(seen),
    );
  }

  factory WalkSummaryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WalkSummaryRow(
      walkId: serializer.fromJson<String>(json['walkId']),
      finishedAt: serializer.fromJson<DateTime>(json['finishedAt']),
      newSegmentCount: serializer.fromJson<int>(json['newSegmentCount']),
      newStreetCount: serializer.fromJson<int>(json['newStreetCount']),
      bridgeCount: serializer.fromJson<int>(json['bridgeCount']),
      knownSegmentCount: serializer.fromJson<int>(json['knownSegmentCount']),
      streetsByEnvironment: serializer.fromJson<String>(
        json['streetsByEnvironment'],
      ),
      creatureGrew: serializer.fromJson<bool>(json['creatureGrew']),
      seen: serializer.fromJson<bool>(json['seen']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'walkId': serializer.toJson<String>(walkId),
      'finishedAt': serializer.toJson<DateTime>(finishedAt),
      'newSegmentCount': serializer.toJson<int>(newSegmentCount),
      'newStreetCount': serializer.toJson<int>(newStreetCount),
      'bridgeCount': serializer.toJson<int>(bridgeCount),
      'knownSegmentCount': serializer.toJson<int>(knownSegmentCount),
      'streetsByEnvironment': serializer.toJson<String>(streetsByEnvironment),
      'creatureGrew': serializer.toJson<bool>(creatureGrew),
      'seen': serializer.toJson<bool>(seen),
    };
  }

  WalkSummaryRow copyWith({
    String? walkId,
    DateTime? finishedAt,
    int? newSegmentCount,
    int? newStreetCount,
    int? bridgeCount,
    int? knownSegmentCount,
    String? streetsByEnvironment,
    bool? creatureGrew,
    bool? seen,
  }) => WalkSummaryRow(
    walkId: walkId ?? this.walkId,
    finishedAt: finishedAt ?? this.finishedAt,
    newSegmentCount: newSegmentCount ?? this.newSegmentCount,
    newStreetCount: newStreetCount ?? this.newStreetCount,
    bridgeCount: bridgeCount ?? this.bridgeCount,
    knownSegmentCount: knownSegmentCount ?? this.knownSegmentCount,
    streetsByEnvironment: streetsByEnvironment ?? this.streetsByEnvironment,
    creatureGrew: creatureGrew ?? this.creatureGrew,
    seen: seen ?? this.seen,
  );
  WalkSummaryRow copyWithCompanion(WalkSummariesCompanion data) {
    return WalkSummaryRow(
      walkId: data.walkId.present ? data.walkId.value : this.walkId,
      finishedAt: data.finishedAt.present
          ? data.finishedAt.value
          : this.finishedAt,
      newSegmentCount: data.newSegmentCount.present
          ? data.newSegmentCount.value
          : this.newSegmentCount,
      newStreetCount: data.newStreetCount.present
          ? data.newStreetCount.value
          : this.newStreetCount,
      bridgeCount: data.bridgeCount.present
          ? data.bridgeCount.value
          : this.bridgeCount,
      knownSegmentCount: data.knownSegmentCount.present
          ? data.knownSegmentCount.value
          : this.knownSegmentCount,
      streetsByEnvironment: data.streetsByEnvironment.present
          ? data.streetsByEnvironment.value
          : this.streetsByEnvironment,
      creatureGrew: data.creatureGrew.present
          ? data.creatureGrew.value
          : this.creatureGrew,
      seen: data.seen.present ? data.seen.value : this.seen,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WalkSummaryRow(')
          ..write('walkId: $walkId, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('newSegmentCount: $newSegmentCount, ')
          ..write('newStreetCount: $newStreetCount, ')
          ..write('bridgeCount: $bridgeCount, ')
          ..write('knownSegmentCount: $knownSegmentCount, ')
          ..write('streetsByEnvironment: $streetsByEnvironment, ')
          ..write('creatureGrew: $creatureGrew, ')
          ..write('seen: $seen')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    walkId,
    finishedAt,
    newSegmentCount,
    newStreetCount,
    bridgeCount,
    knownSegmentCount,
    streetsByEnvironment,
    creatureGrew,
    seen,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WalkSummaryRow &&
          other.walkId == this.walkId &&
          other.finishedAt == this.finishedAt &&
          other.newSegmentCount == this.newSegmentCount &&
          other.newStreetCount == this.newStreetCount &&
          other.bridgeCount == this.bridgeCount &&
          other.knownSegmentCount == this.knownSegmentCount &&
          other.streetsByEnvironment == this.streetsByEnvironment &&
          other.creatureGrew == this.creatureGrew &&
          other.seen == this.seen);
}

class WalkSummariesCompanion extends UpdateCompanion<WalkSummaryRow> {
  final Value<String> walkId;
  final Value<DateTime> finishedAt;
  final Value<int> newSegmentCount;
  final Value<int> newStreetCount;
  final Value<int> bridgeCount;
  final Value<int> knownSegmentCount;
  final Value<String> streetsByEnvironment;
  final Value<bool> creatureGrew;
  final Value<bool> seen;
  final Value<int> rowid;
  const WalkSummariesCompanion({
    this.walkId = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.newSegmentCount = const Value.absent(),
    this.newStreetCount = const Value.absent(),
    this.bridgeCount = const Value.absent(),
    this.knownSegmentCount = const Value.absent(),
    this.streetsByEnvironment = const Value.absent(),
    this.creatureGrew = const Value.absent(),
    this.seen = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WalkSummariesCompanion.insert({
    required String walkId,
    required DateTime finishedAt,
    required int newSegmentCount,
    required int newStreetCount,
    required int bridgeCount,
    this.knownSegmentCount = const Value.absent(),
    required String streetsByEnvironment,
    required bool creatureGrew,
    this.seen = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : walkId = Value(walkId),
       finishedAt = Value(finishedAt),
       newSegmentCount = Value(newSegmentCount),
       newStreetCount = Value(newStreetCount),
       bridgeCount = Value(bridgeCount),
       streetsByEnvironment = Value(streetsByEnvironment),
       creatureGrew = Value(creatureGrew);
  static Insertable<WalkSummaryRow> custom({
    Expression<String>? walkId,
    Expression<DateTime>? finishedAt,
    Expression<int>? newSegmentCount,
    Expression<int>? newStreetCount,
    Expression<int>? bridgeCount,
    Expression<int>? knownSegmentCount,
    Expression<String>? streetsByEnvironment,
    Expression<bool>? creatureGrew,
    Expression<bool>? seen,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (walkId != null) 'walk_id': walkId,
      if (finishedAt != null) 'finished_at': finishedAt,
      if (newSegmentCount != null) 'new_segment_count': newSegmentCount,
      if (newStreetCount != null) 'new_street_count': newStreetCount,
      if (bridgeCount != null) 'bridge_count': bridgeCount,
      if (knownSegmentCount != null) 'known_segment_count': knownSegmentCount,
      if (streetsByEnvironment != null)
        'streets_by_environment': streetsByEnvironment,
      if (creatureGrew != null) 'creature_grew': creatureGrew,
      if (seen != null) 'seen': seen,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WalkSummariesCompanion copyWith({
    Value<String>? walkId,
    Value<DateTime>? finishedAt,
    Value<int>? newSegmentCount,
    Value<int>? newStreetCount,
    Value<int>? bridgeCount,
    Value<int>? knownSegmentCount,
    Value<String>? streetsByEnvironment,
    Value<bool>? creatureGrew,
    Value<bool>? seen,
    Value<int>? rowid,
  }) {
    return WalkSummariesCompanion(
      walkId: walkId ?? this.walkId,
      finishedAt: finishedAt ?? this.finishedAt,
      newSegmentCount: newSegmentCount ?? this.newSegmentCount,
      newStreetCount: newStreetCount ?? this.newStreetCount,
      bridgeCount: bridgeCount ?? this.bridgeCount,
      knownSegmentCount: knownSegmentCount ?? this.knownSegmentCount,
      streetsByEnvironment: streetsByEnvironment ?? this.streetsByEnvironment,
      creatureGrew: creatureGrew ?? this.creatureGrew,
      seen: seen ?? this.seen,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (walkId.present) {
      map['walk_id'] = Variable<String>(walkId.value);
    }
    if (finishedAt.present) {
      map['finished_at'] = Variable<DateTime>(finishedAt.value);
    }
    if (newSegmentCount.present) {
      map['new_segment_count'] = Variable<int>(newSegmentCount.value);
    }
    if (newStreetCount.present) {
      map['new_street_count'] = Variable<int>(newStreetCount.value);
    }
    if (bridgeCount.present) {
      map['bridge_count'] = Variable<int>(bridgeCount.value);
    }
    if (knownSegmentCount.present) {
      map['known_segment_count'] = Variable<int>(knownSegmentCount.value);
    }
    if (streetsByEnvironment.present) {
      map['streets_by_environment'] = Variable<String>(
        streetsByEnvironment.value,
      );
    }
    if (creatureGrew.present) {
      map['creature_grew'] = Variable<bool>(creatureGrew.value);
    }
    if (seen.present) {
      map['seen'] = Variable<bool>(seen.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalkSummariesCompanion(')
          ..write('walkId: $walkId, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('newSegmentCount: $newSegmentCount, ')
          ..write('newStreetCount: $newStreetCount, ')
          ..write('bridgeCount: $bridgeCount, ')
          ..write('knownSegmentCount: $knownSegmentCount, ')
          ..write('streetsByEnvironment: $streetsByEnvironment, ')
          ..write('creatureGrew: $creatureGrew, ')
          ..write('seen: $seen, ')
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
  late final $WalkSummariesTable walkSummaries = $WalkSummariesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    creatureStates,
    knownSegments,
    recordedWalks,
    walkSummaries,
  ];
}

typedef $$CreatureStatesTableCreateCompanionBuilder =
    CreatureStatesCompanion Function({
      Value<int> id,
      Value<int> food,
      Value<String> traitPoints,
      Value<DateTime?> lastFedAt,
      Value<String?> speciesId,
      Value<DateTime?> lastReleasedAt,
    });
typedef $$CreatureStatesTableUpdateCompanionBuilder =
    CreatureStatesCompanion Function({
      Value<int> id,
      Value<int> food,
      Value<String> traitPoints,
      Value<DateTime?> lastFedAt,
      Value<String?> speciesId,
      Value<DateTime?> lastReleasedAt,
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

  ColumnFilters<String> get speciesId => $composableBuilder(
    column: $table.speciesId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastReleasedAt => $composableBuilder(
    column: $table.lastReleasedAt,
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

  ColumnOrderings<String> get speciesId => $composableBuilder(
    column: $table.speciesId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastReleasedAt => $composableBuilder(
    column: $table.lastReleasedAt,
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

  GeneratedColumn<String> get speciesId =>
      $composableBuilder(column: $table.speciesId, builder: (column) => column);

  GeneratedColumn<DateTime> get lastReleasedAt => $composableBuilder(
    column: $table.lastReleasedAt,
    builder: (column) => column,
  );
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
                Value<String?> speciesId = const Value.absent(),
                Value<DateTime?> lastReleasedAt = const Value.absent(),
              }) => CreatureStatesCompanion(
                id: id,
                food: food,
                traitPoints: traitPoints,
                lastFedAt: lastFedAt,
                speciesId: speciesId,
                lastReleasedAt: lastReleasedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> food = const Value.absent(),
                Value<String> traitPoints = const Value.absent(),
                Value<DateTime?> lastFedAt = const Value.absent(),
                Value<String?> speciesId = const Value.absent(),
                Value<DateTime?> lastReleasedAt = const Value.absent(),
              }) => CreatureStatesCompanion.insert(
                id: id,
                food: food,
                traitPoints: traitPoints,
                lastFedAt: lastFedAt,
                speciesId: speciesId,
                lastReleasedAt: lastReleasedAt,
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
      Value<bool> finished,
      Value<int> rowid,
    });
typedef $$RecordedWalksTableUpdateCompanionBuilder =
    RecordedWalksCompanion Function({
      Value<String> id,
      Value<DateTime> startedAt,
      Value<String> gpx,
      Value<DateTime?> processedAt,
      Value<bool> finished,
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

  ColumnFilters<bool> get finished => $composableBuilder(
    column: $table.finished,
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

  ColumnOrderings<bool> get finished => $composableBuilder(
    column: $table.finished,
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

  GeneratedColumn<bool> get finished =>
      $composableBuilder(column: $table.finished, builder: (column) => column);
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
                Value<bool> finished = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecordedWalksCompanion(
                id: id,
                startedAt: startedAt,
                gpx: gpx,
                processedAt: processedAt,
                finished: finished,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime startedAt,
                required String gpx,
                Value<DateTime?> processedAt = const Value.absent(),
                Value<bool> finished = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecordedWalksCompanion.insert(
                id: id,
                startedAt: startedAt,
                gpx: gpx,
                processedAt: processedAt,
                finished: finished,
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
typedef $$WalkSummariesTableCreateCompanionBuilder =
    WalkSummariesCompanion Function({
      required String walkId,
      required DateTime finishedAt,
      required int newSegmentCount,
      required int newStreetCount,
      required int bridgeCount,
      Value<int> knownSegmentCount,
      required String streetsByEnvironment,
      required bool creatureGrew,
      Value<bool> seen,
      Value<int> rowid,
    });
typedef $$WalkSummariesTableUpdateCompanionBuilder =
    WalkSummariesCompanion Function({
      Value<String> walkId,
      Value<DateTime> finishedAt,
      Value<int> newSegmentCount,
      Value<int> newStreetCount,
      Value<int> bridgeCount,
      Value<int> knownSegmentCount,
      Value<String> streetsByEnvironment,
      Value<bool> creatureGrew,
      Value<bool> seen,
      Value<int> rowid,
    });

class $$WalkSummariesTableFilterComposer
    extends Composer<_$AppDatabase, $WalkSummariesTable> {
  $$WalkSummariesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get walkId => $composableBuilder(
    column: $table.walkId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get newSegmentCount => $composableBuilder(
    column: $table.newSegmentCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get newStreetCount => $composableBuilder(
    column: $table.newStreetCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bridgeCount => $composableBuilder(
    column: $table.bridgeCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get knownSegmentCount => $composableBuilder(
    column: $table.knownSegmentCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get streetsByEnvironment => $composableBuilder(
    column: $table.streetsByEnvironment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get creatureGrew => $composableBuilder(
    column: $table.creatureGrew,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get seen => $composableBuilder(
    column: $table.seen,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WalkSummariesTableOrderingComposer
    extends Composer<_$AppDatabase, $WalkSummariesTable> {
  $$WalkSummariesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get walkId => $composableBuilder(
    column: $table.walkId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get newSegmentCount => $composableBuilder(
    column: $table.newSegmentCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get newStreetCount => $composableBuilder(
    column: $table.newStreetCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bridgeCount => $composableBuilder(
    column: $table.bridgeCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get knownSegmentCount => $composableBuilder(
    column: $table.knownSegmentCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get streetsByEnvironment => $composableBuilder(
    column: $table.streetsByEnvironment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get creatureGrew => $composableBuilder(
    column: $table.creatureGrew,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get seen => $composableBuilder(
    column: $table.seen,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WalkSummariesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WalkSummariesTable> {
  $$WalkSummariesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get walkId =>
      $composableBuilder(column: $table.walkId, builder: (column) => column);

  GeneratedColumn<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get newSegmentCount => $composableBuilder(
    column: $table.newSegmentCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get newStreetCount => $composableBuilder(
    column: $table.newStreetCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bridgeCount => $composableBuilder(
    column: $table.bridgeCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get knownSegmentCount => $composableBuilder(
    column: $table.knownSegmentCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get streetsByEnvironment => $composableBuilder(
    column: $table.streetsByEnvironment,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get creatureGrew => $composableBuilder(
    column: $table.creatureGrew,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get seen =>
      $composableBuilder(column: $table.seen, builder: (column) => column);
}

class $$WalkSummariesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WalkSummariesTable,
          WalkSummaryRow,
          $$WalkSummariesTableFilterComposer,
          $$WalkSummariesTableOrderingComposer,
          $$WalkSummariesTableAnnotationComposer,
          $$WalkSummariesTableCreateCompanionBuilder,
          $$WalkSummariesTableUpdateCompanionBuilder,
          (
            WalkSummaryRow,
            BaseReferences<_$AppDatabase, $WalkSummariesTable, WalkSummaryRow>,
          ),
          WalkSummaryRow,
          PrefetchHooks Function()
        > {
  $$WalkSummariesTableTableManager(_$AppDatabase db, $WalkSummariesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalkSummariesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WalkSummariesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WalkSummariesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> walkId = const Value.absent(),
                Value<DateTime> finishedAt = const Value.absent(),
                Value<int> newSegmentCount = const Value.absent(),
                Value<int> newStreetCount = const Value.absent(),
                Value<int> bridgeCount = const Value.absent(),
                Value<int> knownSegmentCount = const Value.absent(),
                Value<String> streetsByEnvironment = const Value.absent(),
                Value<bool> creatureGrew = const Value.absent(),
                Value<bool> seen = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WalkSummariesCompanion(
                walkId: walkId,
                finishedAt: finishedAt,
                newSegmentCount: newSegmentCount,
                newStreetCount: newStreetCount,
                bridgeCount: bridgeCount,
                knownSegmentCount: knownSegmentCount,
                streetsByEnvironment: streetsByEnvironment,
                creatureGrew: creatureGrew,
                seen: seen,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String walkId,
                required DateTime finishedAt,
                required int newSegmentCount,
                required int newStreetCount,
                required int bridgeCount,
                Value<int> knownSegmentCount = const Value.absent(),
                required String streetsByEnvironment,
                required bool creatureGrew,
                Value<bool> seen = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WalkSummariesCompanion.insert(
                walkId: walkId,
                finishedAt: finishedAt,
                newSegmentCount: newSegmentCount,
                newStreetCount: newStreetCount,
                bridgeCount: bridgeCount,
                knownSegmentCount: knownSegmentCount,
                streetsByEnvironment: streetsByEnvironment,
                creatureGrew: creatureGrew,
                seen: seen,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WalkSummariesTable, WalkSummaryRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $WalkSummariesTable,
                    WalkSummaryRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WalkSummariesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WalkSummariesTable,
      WalkSummaryRow,
      $$WalkSummariesTableFilterComposer,
      $$WalkSummariesTableOrderingComposer,
      $$WalkSummariesTableAnnotationComposer,
      $$WalkSummariesTableCreateCompanionBuilder,
      $$WalkSummariesTableUpdateCompanionBuilder,
      (
        WalkSummaryRow,
        BaseReferences<_$AppDatabase, $WalkSummariesTable, WalkSummaryRow>,
      ),
      WalkSummaryRow,
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
  $$WalkSummariesTableTableManager get walkSummaries =>
      $$WalkSummariesTableTableManager(_db, _db.walkSummaries);
}
