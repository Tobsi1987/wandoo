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
  static const VerificationMeta _hatMeta = const VerificationMeta('hat');
  @override
  late final GeneratedColumn<String> hat = GeneratedColumn<String>(
    'hat',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _neckMeta = const VerificationMeta('neck');
  @override
  late final GeneratedColumn<String> neck = GeneratedColumn<String>(
    'neck',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _seenSpeciesMeta = const VerificationMeta(
    'seenSpecies',
  );
  @override
  late final GeneratedColumn<String> seenSpecies = GeneratedColumn<String>(
    'seen_species',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _luckyEggMeta = const VerificationMeta(
    'luckyEgg',
  );
  @override
  late final GeneratedColumn<bool> luckyEgg = GeneratedColumn<bool>(
    'lucky_egg',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("lucky_egg" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _walkedMetersMeta = const VerificationMeta(
    'walkedMeters',
  );
  @override
  late final GeneratedColumn<int> walkedMeters = GeneratedColumn<int>(
    'walked_meters',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    food,
    traitPoints,
    lastFedAt,
    speciesId,
    lastReleasedAt,
    hat,
    neck,
    seenSpecies,
    luckyEgg,
    walkedMeters,
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
    if (data.containsKey('hat')) {
      context.handle(
        _hatMeta,
        hat.isAcceptableOrUnknown(data['hat']!, _hatMeta),
      );
    }
    if (data.containsKey('neck')) {
      context.handle(
        _neckMeta,
        neck.isAcceptableOrUnknown(data['neck']!, _neckMeta),
      );
    }
    if (data.containsKey('seen_species')) {
      context.handle(
        _seenSpeciesMeta,
        seenSpecies.isAcceptableOrUnknown(
          data['seen_species']!,
          _seenSpeciesMeta,
        ),
      );
    }
    if (data.containsKey('lucky_egg')) {
      context.handle(
        _luckyEggMeta,
        luckyEgg.isAcceptableOrUnknown(data['lucky_egg']!, _luckyEggMeta),
      );
    }
    if (data.containsKey('walked_meters')) {
      context.handle(
        _walkedMetersMeta,
        walkedMeters.isAcceptableOrUnknown(
          data['walked_meters']!,
          _walkedMetersMeta,
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
      hat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hat'],
      ),
      neck: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}neck'],
      ),
      seenSpecies: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}seen_species'],
      )!,
      luckyEgg: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}lucky_egg'],
      )!,
      walkedMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}walked_meters'],
      )!,
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

  /// Deko als Name von `CreatureHat`/`CreatureNeck` (seit Schema 7).
  final String? hat;
  final String? neck;

  /// Je geschlüpfte Arten als JSON-Liste, fürs Sammelalbum.
  final String seenSpecies;
  final bool luckyEgg;

  /// Meter, die man mit diesem Wesen schon gegangen ist.
  final int walkedMeters;
  const CreatureState({
    required this.id,
    required this.food,
    required this.traitPoints,
    this.lastFedAt,
    this.speciesId,
    this.lastReleasedAt,
    this.hat,
    this.neck,
    required this.seenSpecies,
    required this.luckyEgg,
    required this.walkedMeters,
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
    if (!nullToAbsent || hat != null) {
      map['hat'] = Variable<String>(hat);
    }
    if (!nullToAbsent || neck != null) {
      map['neck'] = Variable<String>(neck);
    }
    map['seen_species'] = Variable<String>(seenSpecies);
    map['lucky_egg'] = Variable<bool>(luckyEgg);
    map['walked_meters'] = Variable<int>(walkedMeters);
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
      hat: hat == null && nullToAbsent ? const Value.absent() : Value(hat),
      neck: neck == null && nullToAbsent ? const Value.absent() : Value(neck),
      seenSpecies: Value(seenSpecies),
      luckyEgg: Value(luckyEgg),
      walkedMeters: Value(walkedMeters),
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
      hat: serializer.fromJson<String?>(json['hat']),
      neck: serializer.fromJson<String?>(json['neck']),
      seenSpecies: serializer.fromJson<String>(json['seenSpecies']),
      luckyEgg: serializer.fromJson<bool>(json['luckyEgg']),
      walkedMeters: serializer.fromJson<int>(json['walkedMeters']),
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
      'hat': serializer.toJson<String?>(hat),
      'neck': serializer.toJson<String?>(neck),
      'seenSpecies': serializer.toJson<String>(seenSpecies),
      'luckyEgg': serializer.toJson<bool>(luckyEgg),
      'walkedMeters': serializer.toJson<int>(walkedMeters),
    };
  }

  CreatureState copyWith({
    int? id,
    int? food,
    String? traitPoints,
    Value<DateTime?> lastFedAt = const Value.absent(),
    Value<String?> speciesId = const Value.absent(),
    Value<DateTime?> lastReleasedAt = const Value.absent(),
    Value<String?> hat = const Value.absent(),
    Value<String?> neck = const Value.absent(),
    String? seenSpecies,
    bool? luckyEgg,
    int? walkedMeters,
  }) => CreatureState(
    id: id ?? this.id,
    food: food ?? this.food,
    traitPoints: traitPoints ?? this.traitPoints,
    lastFedAt: lastFedAt.present ? lastFedAt.value : this.lastFedAt,
    speciesId: speciesId.present ? speciesId.value : this.speciesId,
    lastReleasedAt: lastReleasedAt.present
        ? lastReleasedAt.value
        : this.lastReleasedAt,
    hat: hat.present ? hat.value : this.hat,
    neck: neck.present ? neck.value : this.neck,
    seenSpecies: seenSpecies ?? this.seenSpecies,
    luckyEgg: luckyEgg ?? this.luckyEgg,
    walkedMeters: walkedMeters ?? this.walkedMeters,
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
      hat: data.hat.present ? data.hat.value : this.hat,
      neck: data.neck.present ? data.neck.value : this.neck,
      seenSpecies: data.seenSpecies.present
          ? data.seenSpecies.value
          : this.seenSpecies,
      luckyEgg: data.luckyEgg.present ? data.luckyEgg.value : this.luckyEgg,
      walkedMeters: data.walkedMeters.present
          ? data.walkedMeters.value
          : this.walkedMeters,
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
          ..write('lastReleasedAt: $lastReleasedAt, ')
          ..write('hat: $hat, ')
          ..write('neck: $neck, ')
          ..write('seenSpecies: $seenSpecies, ')
          ..write('luckyEgg: $luckyEgg, ')
          ..write('walkedMeters: $walkedMeters')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    food,
    traitPoints,
    lastFedAt,
    speciesId,
    lastReleasedAt,
    hat,
    neck,
    seenSpecies,
    luckyEgg,
    walkedMeters,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CreatureState &&
          other.id == this.id &&
          other.food == this.food &&
          other.traitPoints == this.traitPoints &&
          other.lastFedAt == this.lastFedAt &&
          other.speciesId == this.speciesId &&
          other.lastReleasedAt == this.lastReleasedAt &&
          other.hat == this.hat &&
          other.neck == this.neck &&
          other.seenSpecies == this.seenSpecies &&
          other.luckyEgg == this.luckyEgg &&
          other.walkedMeters == this.walkedMeters);
}

class CreatureStatesCompanion extends UpdateCompanion<CreatureState> {
  final Value<int> id;
  final Value<int> food;
  final Value<String> traitPoints;
  final Value<DateTime?> lastFedAt;
  final Value<String?> speciesId;
  final Value<DateTime?> lastReleasedAt;
  final Value<String?> hat;
  final Value<String?> neck;
  final Value<String> seenSpecies;
  final Value<bool> luckyEgg;
  final Value<int> walkedMeters;
  const CreatureStatesCompanion({
    this.id = const Value.absent(),
    this.food = const Value.absent(),
    this.traitPoints = const Value.absent(),
    this.lastFedAt = const Value.absent(),
    this.speciesId = const Value.absent(),
    this.lastReleasedAt = const Value.absent(),
    this.hat = const Value.absent(),
    this.neck = const Value.absent(),
    this.seenSpecies = const Value.absent(),
    this.luckyEgg = const Value.absent(),
    this.walkedMeters = const Value.absent(),
  });
  CreatureStatesCompanion.insert({
    this.id = const Value.absent(),
    this.food = const Value.absent(),
    this.traitPoints = const Value.absent(),
    this.lastFedAt = const Value.absent(),
    this.speciesId = const Value.absent(),
    this.lastReleasedAt = const Value.absent(),
    this.hat = const Value.absent(),
    this.neck = const Value.absent(),
    this.seenSpecies = const Value.absent(),
    this.luckyEgg = const Value.absent(),
    this.walkedMeters = const Value.absent(),
  });
  static Insertable<CreatureState> custom({
    Expression<int>? id,
    Expression<int>? food,
    Expression<String>? traitPoints,
    Expression<DateTime>? lastFedAt,
    Expression<String>? speciesId,
    Expression<DateTime>? lastReleasedAt,
    Expression<String>? hat,
    Expression<String>? neck,
    Expression<String>? seenSpecies,
    Expression<bool>? luckyEgg,
    Expression<int>? walkedMeters,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (food != null) 'food': food,
      if (traitPoints != null) 'trait_points': traitPoints,
      if (lastFedAt != null) 'last_fed_at': lastFedAt,
      if (speciesId != null) 'species_id': speciesId,
      if (lastReleasedAt != null) 'last_released_at': lastReleasedAt,
      if (hat != null) 'hat': hat,
      if (neck != null) 'neck': neck,
      if (seenSpecies != null) 'seen_species': seenSpecies,
      if (luckyEgg != null) 'lucky_egg': luckyEgg,
      if (walkedMeters != null) 'walked_meters': walkedMeters,
    });
  }

  CreatureStatesCompanion copyWith({
    Value<int>? id,
    Value<int>? food,
    Value<String>? traitPoints,
    Value<DateTime?>? lastFedAt,
    Value<String?>? speciesId,
    Value<DateTime?>? lastReleasedAt,
    Value<String?>? hat,
    Value<String?>? neck,
    Value<String>? seenSpecies,
    Value<bool>? luckyEgg,
    Value<int>? walkedMeters,
  }) {
    return CreatureStatesCompanion(
      id: id ?? this.id,
      food: food ?? this.food,
      traitPoints: traitPoints ?? this.traitPoints,
      lastFedAt: lastFedAt ?? this.lastFedAt,
      speciesId: speciesId ?? this.speciesId,
      lastReleasedAt: lastReleasedAt ?? this.lastReleasedAt,
      hat: hat ?? this.hat,
      neck: neck ?? this.neck,
      seenSpecies: seenSpecies ?? this.seenSpecies,
      luckyEgg: luckyEgg ?? this.luckyEgg,
      walkedMeters: walkedMeters ?? this.walkedMeters,
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
    if (hat.present) {
      map['hat'] = Variable<String>(hat.value);
    }
    if (neck.present) {
      map['neck'] = Variable<String>(neck.value);
    }
    if (seenSpecies.present) {
      map['seen_species'] = Variable<String>(seenSpecies.value);
    }
    if (luckyEgg.present) {
      map['lucky_egg'] = Variable<bool>(luckyEgg.value);
    }
    if (walkedMeters.present) {
      map['walked_meters'] = Variable<int>(walkedMeters.value);
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
          ..write('lastReleasedAt: $lastReleasedAt, ')
          ..write('hat: $hat, ')
          ..write('neck: $neck, ')
          ..write('seenSpecies: $seenSpecies, ')
          ..write('luckyEgg: $luckyEgg, ')
          ..write('walkedMeters: $walkedMeters')
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
  static const VerificationMeta _extraLinesMeta = const VerificationMeta(
    'extraLines',
  );
  @override
  late final GeneratedColumn<String> extraLines = GeneratedColumn<String>(
    'extra_lines',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _distanceMetersMeta = const VerificationMeta(
    'distanceMeters',
  );
  @override
  late final GeneratedColumn<int> distanceMeters = GeneratedColumn<int>(
    'distance_meters',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    extraLines,
    distanceMeters,
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
    if (data.containsKey('extra_lines')) {
      context.handle(
        _extraLinesMeta,
        extraLines.isAcceptableOrUnknown(data['extra_lines']!, _extraLinesMeta),
      );
    }
    if (data.containsKey('distance_meters')) {
      context.handle(
        _distanceMetersMeta,
        distanceMeters.isAcceptableOrUnknown(
          data['distance_meters']!,
          _distanceMetersMeta,
        ),
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
      extraLines: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extra_lines'],
      )!,
      distanceMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}distance_meters'],
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

  /// Zusätzliche Zeilen anderer Features als JSON-Liste, z. B. Fundstücke
  /// (seit Schema 7).
  final String extraLines;

  /// Länge des Gangs in Metern.
  final int distanceMeters;
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
    required this.extraLines,
    required this.distanceMeters,
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
    map['extra_lines'] = Variable<String>(extraLines);
    map['distance_meters'] = Variable<int>(distanceMeters);
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
      extraLines: Value(extraLines),
      distanceMeters: Value(distanceMeters),
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
      extraLines: serializer.fromJson<String>(json['extraLines']),
      distanceMeters: serializer.fromJson<int>(json['distanceMeters']),
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
      'extraLines': serializer.toJson<String>(extraLines),
      'distanceMeters': serializer.toJson<int>(distanceMeters),
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
    String? extraLines,
    int? distanceMeters,
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
    extraLines: extraLines ?? this.extraLines,
    distanceMeters: distanceMeters ?? this.distanceMeters,
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
      extraLines: data.extraLines.present
          ? data.extraLines.value
          : this.extraLines,
      distanceMeters: data.distanceMeters.present
          ? data.distanceMeters.value
          : this.distanceMeters,
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
          ..write('seen: $seen, ')
          ..write('extraLines: $extraLines, ')
          ..write('distanceMeters: $distanceMeters')
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
    extraLines,
    distanceMeters,
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
          other.seen == this.seen &&
          other.extraLines == this.extraLines &&
          other.distanceMeters == this.distanceMeters);
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
  final Value<String> extraLines;
  final Value<int> distanceMeters;
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
    this.extraLines = const Value.absent(),
    this.distanceMeters = const Value.absent(),
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
    this.extraLines = const Value.absent(),
    this.distanceMeters = const Value.absent(),
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
    Expression<String>? extraLines,
    Expression<int>? distanceMeters,
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
      if (extraLines != null) 'extra_lines': extraLines,
      if (distanceMeters != null) 'distance_meters': distanceMeters,
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
    Value<String>? extraLines,
    Value<int>? distanceMeters,
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
      extraLines: extraLines ?? this.extraLines,
      distanceMeters: distanceMeters ?? this.distanceMeters,
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
    if (extraLines.present) {
      map['extra_lines'] = Variable<String>(extraLines.value);
    }
    if (distanceMeters.present) {
      map['distance_meters'] = Variable<int>(distanceMeters.value);
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
          ..write('extraLines: $extraLines, ')
          ..write('distanceMeters: $distanceMeters, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TreasureStatesTable extends TreasureStates
    with TableInfo<$TreasureStatesTable, TreasureState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TreasureStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _findsMeta = const VerificationMeta('finds');
  @override
  late final GeneratedColumn<String> finds = GeneratedColumn<String>(
    'finds',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _ownedMeta = const VerificationMeta('owned');
  @override
  late final GeneratedColumn<String> owned = GeneratedColumn<String>(
    'owned',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, finds, owned];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'treasure_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<TreasureState> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('finds')) {
      context.handle(
        _findsMeta,
        finds.isAcceptableOrUnknown(data['finds']!, _findsMeta),
      );
    }
    if (data.containsKey('owned')) {
      context.handle(
        _ownedMeta,
        owned.isAcceptableOrUnknown(data['owned']!, _ownedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TreasureState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TreasureState(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      finds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}finds'],
      )!,
      owned: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owned'],
      )!,
    );
  }

  @override
  $TreasureStatesTable createAlias(String alias) {
    return $TreasureStatesTable(attachedDatabase, alias);
  }
}

class TreasureState extends DataClass implements Insertable<TreasureState> {
  final int id;

  /// Anzahl je `Find` als JSON, z. B. `{"acorn":2}`.
  final String finds;

  /// Gebastelte `Accessory`-Namen als JSON-Liste.
  final String owned;
  const TreasureState({
    required this.id,
    required this.finds,
    required this.owned,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['finds'] = Variable<String>(finds);
    map['owned'] = Variable<String>(owned);
    return map;
  }

  TreasureStatesCompanion toCompanion(bool nullToAbsent) {
    return TreasureStatesCompanion(
      id: Value(id),
      finds: Value(finds),
      owned: Value(owned),
    );
  }

  factory TreasureState.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TreasureState(
      id: serializer.fromJson<int>(json['id']),
      finds: serializer.fromJson<String>(json['finds']),
      owned: serializer.fromJson<String>(json['owned']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'finds': serializer.toJson<String>(finds),
      'owned': serializer.toJson<String>(owned),
    };
  }

  TreasureState copyWith({int? id, String? finds, String? owned}) =>
      TreasureState(
        id: id ?? this.id,
        finds: finds ?? this.finds,
        owned: owned ?? this.owned,
      );
  TreasureState copyWithCompanion(TreasureStatesCompanion data) {
    return TreasureState(
      id: data.id.present ? data.id.value : this.id,
      finds: data.finds.present ? data.finds.value : this.finds,
      owned: data.owned.present ? data.owned.value : this.owned,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TreasureState(')
          ..write('id: $id, ')
          ..write('finds: $finds, ')
          ..write('owned: $owned')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, finds, owned);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TreasureState &&
          other.id == this.id &&
          other.finds == this.finds &&
          other.owned == this.owned);
}

class TreasureStatesCompanion extends UpdateCompanion<TreasureState> {
  final Value<int> id;
  final Value<String> finds;
  final Value<String> owned;
  const TreasureStatesCompanion({
    this.id = const Value.absent(),
    this.finds = const Value.absent(),
    this.owned = const Value.absent(),
  });
  TreasureStatesCompanion.insert({
    this.id = const Value.absent(),
    this.finds = const Value.absent(),
    this.owned = const Value.absent(),
  });
  static Insertable<TreasureState> custom({
    Expression<int>? id,
    Expression<String>? finds,
    Expression<String>? owned,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (finds != null) 'finds': finds,
      if (owned != null) 'owned': owned,
    });
  }

  TreasureStatesCompanion copyWith({
    Value<int>? id,
    Value<String>? finds,
    Value<String>? owned,
  }) {
    return TreasureStatesCompanion(
      id: id ?? this.id,
      finds: finds ?? this.finds,
      owned: owned ?? this.owned,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (finds.present) {
      map['finds'] = Variable<String>(finds.value);
    }
    if (owned.present) {
      map['owned'] = Variable<String>(owned.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TreasureStatesCompanion(')
          ..write('id: $id, ')
          ..write('finds: $finds, ')
          ..write('owned: $owned')
          ..write(')'))
        .toString();
  }
}

class $AdventureStatesTable extends AdventureStates
    with TableInfo<$AdventureStatesTable, AdventureState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AdventureStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weekStartMeta = const VerificationMeta(
    'weekStart',
  );
  @override
  late final GeneratedColumn<DateTime> weekStart = GeneratedColumn<DateTime>(
    'week_start',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questsMeta = const VerificationMeta('quests');
  @override
  late final GeneratedColumn<String> quests = GeneratedColumn<String>(
    'quests',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bonusClaimedMeta = const VerificationMeta(
    'bonusClaimed',
  );
  @override
  late final GeneratedColumn<bool> bonusClaimed = GeneratedColumn<bool>(
    'bonus_claimed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("bonus_claimed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, weekStart, quests, bonusClaimed];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'adventure_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<AdventureState> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('week_start')) {
      context.handle(
        _weekStartMeta,
        weekStart.isAcceptableOrUnknown(data['week_start']!, _weekStartMeta),
      );
    } else if (isInserting) {
      context.missing(_weekStartMeta);
    }
    if (data.containsKey('quests')) {
      context.handle(
        _questsMeta,
        quests.isAcceptableOrUnknown(data['quests']!, _questsMeta),
      );
    } else if (isInserting) {
      context.missing(_questsMeta);
    }
    if (data.containsKey('bonus_claimed')) {
      context.handle(
        _bonusClaimedMeta,
        bonusClaimed.isAcceptableOrUnknown(
          data['bonus_claimed']!,
          _bonusClaimedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AdventureState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AdventureState(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      weekStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}week_start'],
      )!,
      quests: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quests'],
      )!,
      bonusClaimed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}bonus_claimed'],
      )!,
    );
  }

  @override
  $AdventureStatesTable createAlias(String alias) {
    return $AdventureStatesTable(attachedDatabase, alias);
  }
}

class AdventureState extends DataClass implements Insertable<AdventureState> {
  final int id;
  final DateTime weekStart;

  /// Die Abenteuer als JSON-Liste.
  final String quests;
  final bool bonusClaimed;
  const AdventureState({
    required this.id,
    required this.weekStart,
    required this.quests,
    required this.bonusClaimed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['week_start'] = Variable<DateTime>(weekStart);
    map['quests'] = Variable<String>(quests);
    map['bonus_claimed'] = Variable<bool>(bonusClaimed);
    return map;
  }

  AdventureStatesCompanion toCompanion(bool nullToAbsent) {
    return AdventureStatesCompanion(
      id: Value(id),
      weekStart: Value(weekStart),
      quests: Value(quests),
      bonusClaimed: Value(bonusClaimed),
    );
  }

  factory AdventureState.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AdventureState(
      id: serializer.fromJson<int>(json['id']),
      weekStart: serializer.fromJson<DateTime>(json['weekStart']),
      quests: serializer.fromJson<String>(json['quests']),
      bonusClaimed: serializer.fromJson<bool>(json['bonusClaimed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'weekStart': serializer.toJson<DateTime>(weekStart),
      'quests': serializer.toJson<String>(quests),
      'bonusClaimed': serializer.toJson<bool>(bonusClaimed),
    };
  }

  AdventureState copyWith({
    int? id,
    DateTime? weekStart,
    String? quests,
    bool? bonusClaimed,
  }) => AdventureState(
    id: id ?? this.id,
    weekStart: weekStart ?? this.weekStart,
    quests: quests ?? this.quests,
    bonusClaimed: bonusClaimed ?? this.bonusClaimed,
  );
  AdventureState copyWithCompanion(AdventureStatesCompanion data) {
    return AdventureState(
      id: data.id.present ? data.id.value : this.id,
      weekStart: data.weekStart.present ? data.weekStart.value : this.weekStart,
      quests: data.quests.present ? data.quests.value : this.quests,
      bonusClaimed: data.bonusClaimed.present
          ? data.bonusClaimed.value
          : this.bonusClaimed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AdventureState(')
          ..write('id: $id, ')
          ..write('weekStart: $weekStart, ')
          ..write('quests: $quests, ')
          ..write('bonusClaimed: $bonusClaimed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, weekStart, quests, bonusClaimed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AdventureState &&
          other.id == this.id &&
          other.weekStart == this.weekStart &&
          other.quests == this.quests &&
          other.bonusClaimed == this.bonusClaimed);
}

class AdventureStatesCompanion extends UpdateCompanion<AdventureState> {
  final Value<int> id;
  final Value<DateTime> weekStart;
  final Value<String> quests;
  final Value<bool> bonusClaimed;
  const AdventureStatesCompanion({
    this.id = const Value.absent(),
    this.weekStart = const Value.absent(),
    this.quests = const Value.absent(),
    this.bonusClaimed = const Value.absent(),
  });
  AdventureStatesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime weekStart,
    required String quests,
    this.bonusClaimed = const Value.absent(),
  }) : weekStart = Value(weekStart),
       quests = Value(quests);
  static Insertable<AdventureState> custom({
    Expression<int>? id,
    Expression<DateTime>? weekStart,
    Expression<String>? quests,
    Expression<bool>? bonusClaimed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (weekStart != null) 'week_start': weekStart,
      if (quests != null) 'quests': quests,
      if (bonusClaimed != null) 'bonus_claimed': bonusClaimed,
    });
  }

  AdventureStatesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? weekStart,
    Value<String>? quests,
    Value<bool>? bonusClaimed,
  }) {
    return AdventureStatesCompanion(
      id: id ?? this.id,
      weekStart: weekStart ?? this.weekStart,
      quests: quests ?? this.quests,
      bonusClaimed: bonusClaimed ?? this.bonusClaimed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (weekStart.present) {
      map['week_start'] = Variable<DateTime>(weekStart.value);
    }
    if (quests.present) {
      map['quests'] = Variable<String>(quests.value);
    }
    if (bonusClaimed.present) {
      map['bonus_claimed'] = Variable<bool>(bonusClaimed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AdventureStatesCompanion(')
          ..write('id: $id, ')
          ..write('weekStart: $weekStart, ')
          ..write('quests: $quests, ')
          ..write('bonusClaimed: $bonusClaimed')
          ..write(')'))
        .toString();
  }
}

class $FriendshipStatesTable extends FriendshipStates
    with TableInfo<$FriendshipStatesTable, FriendshipState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FriendshipStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _creatureKeyMeta = const VerificationMeta(
    'creatureKey',
  );
  @override
  late final GeneratedColumn<String> creatureKey = GeneratedColumn<String>(
    'creature_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pointsMeta = const VerificationMeta('points');
  @override
  late final GeneratedColumn<int> points = GeneratedColumn<int>(
    'points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _petsTodayMeta = const VerificationMeta(
    'petsToday',
  );
  @override
  late final GeneratedColumn<int> petsToday = GeneratedColumn<int>(
    'pets_today',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _petDayMeta = const VerificationMeta('petDay');
  @override
  late final GeneratedColumn<DateTime> petDay = GeneratedColumn<DateTime>(
    'pet_day',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    creatureKey,
    points,
    petsToday,
    petDay,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'friendship_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<FriendshipState> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('creature_key')) {
      context.handle(
        _creatureKeyMeta,
        creatureKey.isAcceptableOrUnknown(
          data['creature_key']!,
          _creatureKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_creatureKeyMeta);
    }
    if (data.containsKey('points')) {
      context.handle(
        _pointsMeta,
        points.isAcceptableOrUnknown(data['points']!, _pointsMeta),
      );
    }
    if (data.containsKey('pets_today')) {
      context.handle(
        _petsTodayMeta,
        petsToday.isAcceptableOrUnknown(data['pets_today']!, _petsTodayMeta),
      );
    }
    if (data.containsKey('pet_day')) {
      context.handle(
        _petDayMeta,
        petDay.isAcceptableOrUnknown(data['pet_day']!, _petDayMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FriendshipState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FriendshipState(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      creatureKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}creature_key'],
      )!,
      points: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}points'],
      )!,
      petsToday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pets_today'],
      )!,
      petDay: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}pet_day'],
      ),
    );
  }

  @override
  $FriendshipStatesTable createAlias(String alias) {
    return $FriendshipStatesTable(attachedDatabase, alias);
  }
}

class FriendshipState extends DataClass implements Insertable<FriendshipState> {
  final int id;

  /// Zu welchem Wesen die Punkte gehören (`Creature.lineKey`).
  final String creatureKey;
  final int points;
  final int petsToday;
  final DateTime? petDay;
  const FriendshipState({
    required this.id,
    required this.creatureKey,
    required this.points,
    required this.petsToday,
    this.petDay,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['creature_key'] = Variable<String>(creatureKey);
    map['points'] = Variable<int>(points);
    map['pets_today'] = Variable<int>(petsToday);
    if (!nullToAbsent || petDay != null) {
      map['pet_day'] = Variable<DateTime>(petDay);
    }
    return map;
  }

  FriendshipStatesCompanion toCompanion(bool nullToAbsent) {
    return FriendshipStatesCompanion(
      id: Value(id),
      creatureKey: Value(creatureKey),
      points: Value(points),
      petsToday: Value(petsToday),
      petDay: petDay == null && nullToAbsent
          ? const Value.absent()
          : Value(petDay),
    );
  }

  factory FriendshipState.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FriendshipState(
      id: serializer.fromJson<int>(json['id']),
      creatureKey: serializer.fromJson<String>(json['creatureKey']),
      points: serializer.fromJson<int>(json['points']),
      petsToday: serializer.fromJson<int>(json['petsToday']),
      petDay: serializer.fromJson<DateTime?>(json['petDay']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'creatureKey': serializer.toJson<String>(creatureKey),
      'points': serializer.toJson<int>(points),
      'petsToday': serializer.toJson<int>(petsToday),
      'petDay': serializer.toJson<DateTime?>(petDay),
    };
  }

  FriendshipState copyWith({
    int? id,
    String? creatureKey,
    int? points,
    int? petsToday,
    Value<DateTime?> petDay = const Value.absent(),
  }) => FriendshipState(
    id: id ?? this.id,
    creatureKey: creatureKey ?? this.creatureKey,
    points: points ?? this.points,
    petsToday: petsToday ?? this.petsToday,
    petDay: petDay.present ? petDay.value : this.petDay,
  );
  FriendshipState copyWithCompanion(FriendshipStatesCompanion data) {
    return FriendshipState(
      id: data.id.present ? data.id.value : this.id,
      creatureKey: data.creatureKey.present
          ? data.creatureKey.value
          : this.creatureKey,
      points: data.points.present ? data.points.value : this.points,
      petsToday: data.petsToday.present ? data.petsToday.value : this.petsToday,
      petDay: data.petDay.present ? data.petDay.value : this.petDay,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FriendshipState(')
          ..write('id: $id, ')
          ..write('creatureKey: $creatureKey, ')
          ..write('points: $points, ')
          ..write('petsToday: $petsToday, ')
          ..write('petDay: $petDay')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, creatureKey, points, petsToday, petDay);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FriendshipState &&
          other.id == this.id &&
          other.creatureKey == this.creatureKey &&
          other.points == this.points &&
          other.petsToday == this.petsToday &&
          other.petDay == this.petDay);
}

class FriendshipStatesCompanion extends UpdateCompanion<FriendshipState> {
  final Value<int> id;
  final Value<String> creatureKey;
  final Value<int> points;
  final Value<int> petsToday;
  final Value<DateTime?> petDay;
  const FriendshipStatesCompanion({
    this.id = const Value.absent(),
    this.creatureKey = const Value.absent(),
    this.points = const Value.absent(),
    this.petsToday = const Value.absent(),
    this.petDay = const Value.absent(),
  });
  FriendshipStatesCompanion.insert({
    this.id = const Value.absent(),
    required String creatureKey,
    this.points = const Value.absent(),
    this.petsToday = const Value.absent(),
    this.petDay = const Value.absent(),
  }) : creatureKey = Value(creatureKey);
  static Insertable<FriendshipState> custom({
    Expression<int>? id,
    Expression<String>? creatureKey,
    Expression<int>? points,
    Expression<int>? petsToday,
    Expression<DateTime>? petDay,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (creatureKey != null) 'creature_key': creatureKey,
      if (points != null) 'points': points,
      if (petsToday != null) 'pets_today': petsToday,
      if (petDay != null) 'pet_day': petDay,
    });
  }

  FriendshipStatesCompanion copyWith({
    Value<int>? id,
    Value<String>? creatureKey,
    Value<int>? points,
    Value<int>? petsToday,
    Value<DateTime?>? petDay,
  }) {
    return FriendshipStatesCompanion(
      id: id ?? this.id,
      creatureKey: creatureKey ?? this.creatureKey,
      points: points ?? this.points,
      petsToday: petsToday ?? this.petsToday,
      petDay: petDay ?? this.petDay,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (creatureKey.present) {
      map['creature_key'] = Variable<String>(creatureKey.value);
    }
    if (points.present) {
      map['points'] = Variable<int>(points.value);
    }
    if (petsToday.present) {
      map['pets_today'] = Variable<int>(petsToday.value);
    }
    if (petDay.present) {
      map['pet_day'] = Variable<DateTime>(petDay.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FriendshipStatesCompanion(')
          ..write('id: $id, ')
          ..write('creatureKey: $creatureKey, ')
          ..write('points: $points, ')
          ..write('petsToday: $petsToday, ')
          ..write('petDay: $petDay')
          ..write(')'))
        .toString();
  }
}

class $DiaryWalksTable extends DiaryWalks
    with TableInfo<$DiaryWalksTable, DiaryWalkRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiaryWalksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _walkIdMeta = const VerificationMeta('walkId');
  @override
  late final GeneratedColumn<String> walkId = GeneratedColumn<String>(
    'walk_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creatureKeyMeta = const VerificationMeta(
    'creatureKey',
  );
  @override
  late final GeneratedColumn<String> creatureKey = GeneratedColumn<String>(
    'creature_key',
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
  static const VerificationMeta _metersMeta = const VerificationMeta('meters');
  @override
  late final GeneratedColumn<int> meters = GeneratedColumn<int>(
    'meters',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    walkId,
    creatureKey,
    finishedAt,
    meters,
    path,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'diary_walks';
  @override
  VerificationContext validateIntegrity(
    Insertable<DiaryWalkRow> instance, {
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
    if (data.containsKey('creature_key')) {
      context.handle(
        _creatureKeyMeta,
        creatureKey.isAcceptableOrUnknown(
          data['creature_key']!,
          _creatureKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_creatureKeyMeta);
    }
    if (data.containsKey('finished_at')) {
      context.handle(
        _finishedAtMeta,
        finishedAt.isAcceptableOrUnknown(data['finished_at']!, _finishedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_finishedAtMeta);
    }
    if (data.containsKey('meters')) {
      context.handle(
        _metersMeta,
        meters.isAcceptableOrUnknown(data['meters']!, _metersMeta),
      );
    } else if (isInserting) {
      context.missing(_metersMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {walkId};
  @override
  DiaryWalkRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiaryWalkRow(
      walkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}walk_id'],
      )!,
      creatureKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}creature_key'],
      )!,
      finishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}finished_at'],
      )!,
      meters: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}meters'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
    );
  }

  @override
  $DiaryWalksTable createAlias(String alias) {
    return $DiaryWalksTable(attachedDatabase, alias);
  }
}

class DiaryWalkRow extends DataClass implements Insertable<DiaryWalkRow> {
  final String walkId;
  final String creatureKey;
  final DateTime finishedAt;
  final int meters;

  /// Ausgedünnte Spur als JSON, z. B. `[[52.1,7.6],[52.2,7.6]]`.
  final String path;
  const DiaryWalkRow({
    required this.walkId,
    required this.creatureKey,
    required this.finishedAt,
    required this.meters,
    required this.path,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['walk_id'] = Variable<String>(walkId);
    map['creature_key'] = Variable<String>(creatureKey);
    map['finished_at'] = Variable<DateTime>(finishedAt);
    map['meters'] = Variable<int>(meters);
    map['path'] = Variable<String>(path);
    return map;
  }

  DiaryWalksCompanion toCompanion(bool nullToAbsent) {
    return DiaryWalksCompanion(
      walkId: Value(walkId),
      creatureKey: Value(creatureKey),
      finishedAt: Value(finishedAt),
      meters: Value(meters),
      path: Value(path),
    );
  }

  factory DiaryWalkRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiaryWalkRow(
      walkId: serializer.fromJson<String>(json['walkId']),
      creatureKey: serializer.fromJson<String>(json['creatureKey']),
      finishedAt: serializer.fromJson<DateTime>(json['finishedAt']),
      meters: serializer.fromJson<int>(json['meters']),
      path: serializer.fromJson<String>(json['path']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'walkId': serializer.toJson<String>(walkId),
      'creatureKey': serializer.toJson<String>(creatureKey),
      'finishedAt': serializer.toJson<DateTime>(finishedAt),
      'meters': serializer.toJson<int>(meters),
      'path': serializer.toJson<String>(path),
    };
  }

  DiaryWalkRow copyWith({
    String? walkId,
    String? creatureKey,
    DateTime? finishedAt,
    int? meters,
    String? path,
  }) => DiaryWalkRow(
    walkId: walkId ?? this.walkId,
    creatureKey: creatureKey ?? this.creatureKey,
    finishedAt: finishedAt ?? this.finishedAt,
    meters: meters ?? this.meters,
    path: path ?? this.path,
  );
  DiaryWalkRow copyWithCompanion(DiaryWalksCompanion data) {
    return DiaryWalkRow(
      walkId: data.walkId.present ? data.walkId.value : this.walkId,
      creatureKey: data.creatureKey.present
          ? data.creatureKey.value
          : this.creatureKey,
      finishedAt: data.finishedAt.present
          ? data.finishedAt.value
          : this.finishedAt,
      meters: data.meters.present ? data.meters.value : this.meters,
      path: data.path.present ? data.path.value : this.path,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiaryWalkRow(')
          ..write('walkId: $walkId, ')
          ..write('creatureKey: $creatureKey, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('meters: $meters, ')
          ..write('path: $path')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(walkId, creatureKey, finishedAt, meters, path);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiaryWalkRow &&
          other.walkId == this.walkId &&
          other.creatureKey == this.creatureKey &&
          other.finishedAt == this.finishedAt &&
          other.meters == this.meters &&
          other.path == this.path);
}

class DiaryWalksCompanion extends UpdateCompanion<DiaryWalkRow> {
  final Value<String> walkId;
  final Value<String> creatureKey;
  final Value<DateTime> finishedAt;
  final Value<int> meters;
  final Value<String> path;
  final Value<int> rowid;
  const DiaryWalksCompanion({
    this.walkId = const Value.absent(),
    this.creatureKey = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.meters = const Value.absent(),
    this.path = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DiaryWalksCompanion.insert({
    required String walkId,
    required String creatureKey,
    required DateTime finishedAt,
    required int meters,
    required String path,
    this.rowid = const Value.absent(),
  }) : walkId = Value(walkId),
       creatureKey = Value(creatureKey),
       finishedAt = Value(finishedAt),
       meters = Value(meters),
       path = Value(path);
  static Insertable<DiaryWalkRow> custom({
    Expression<String>? walkId,
    Expression<String>? creatureKey,
    Expression<DateTime>? finishedAt,
    Expression<int>? meters,
    Expression<String>? path,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (walkId != null) 'walk_id': walkId,
      if (creatureKey != null) 'creature_key': creatureKey,
      if (finishedAt != null) 'finished_at': finishedAt,
      if (meters != null) 'meters': meters,
      if (path != null) 'path': path,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DiaryWalksCompanion copyWith({
    Value<String>? walkId,
    Value<String>? creatureKey,
    Value<DateTime>? finishedAt,
    Value<int>? meters,
    Value<String>? path,
    Value<int>? rowid,
  }) {
    return DiaryWalksCompanion(
      walkId: walkId ?? this.walkId,
      creatureKey: creatureKey ?? this.creatureKey,
      finishedAt: finishedAt ?? this.finishedAt,
      meters: meters ?? this.meters,
      path: path ?? this.path,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (walkId.present) {
      map['walk_id'] = Variable<String>(walkId.value);
    }
    if (creatureKey.present) {
      map['creature_key'] = Variable<String>(creatureKey.value);
    }
    if (finishedAt.present) {
      map['finished_at'] = Variable<DateTime>(finishedAt.value);
    }
    if (meters.present) {
      map['meters'] = Variable<int>(meters.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiaryWalksCompanion(')
          ..write('walkId: $walkId, ')
          ..write('creatureKey: $creatureKey, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('meters: $meters, ')
          ..write('path: $path, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DiaryMemoriesTable extends DiaryMemories
    with TableInfo<$DiaryMemoriesTable, DiaryMemoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiaryMemoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _creatureKeyMeta = const VerificationMeta(
    'creatureKey',
  );
  @override
  late final GeneratedColumn<String> creatureKey = GeneratedColumn<String>(
    'creature_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
    'emoji',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    creatureKey,
    at,
    emoji,
    title,
    latitude,
    longitude,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'diary_memories';
  @override
  VerificationContext validateIntegrity(
    Insertable<DiaryMemoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('creature_key')) {
      context.handle(
        _creatureKeyMeta,
        creatureKey.isAcceptableOrUnknown(
          data['creature_key']!,
          _creatureKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_creatureKeyMeta);
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    if (data.containsKey('emoji')) {
      context.handle(
        _emojiMeta,
        emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta),
      );
    } else if (isInserting) {
      context.missing(_emojiMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiaryMemoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiaryMemoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      creatureKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}creature_key'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
      emoji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emoji'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
    );
  }

  @override
  $DiaryMemoriesTable createAlias(String alias) {
    return $DiaryMemoriesTable(attachedDatabase, alias);
  }
}

class DiaryMemoryRow extends DataClass implements Insertable<DiaryMemoryRow> {
  final int id;
  final String creatureKey;
  final DateTime at;
  final String emoji;
  final String title;
  final double? latitude;
  final double? longitude;
  const DiaryMemoryRow({
    required this.id,
    required this.creatureKey,
    required this.at,
    required this.emoji,
    required this.title,
    this.latitude,
    this.longitude,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['creature_key'] = Variable<String>(creatureKey);
    map['at'] = Variable<DateTime>(at);
    map['emoji'] = Variable<String>(emoji);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    return map;
  }

  DiaryMemoriesCompanion toCompanion(bool nullToAbsent) {
    return DiaryMemoriesCompanion(
      id: Value(id),
      creatureKey: Value(creatureKey),
      at: Value(at),
      emoji: Value(emoji),
      title: Value(title),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
    );
  }

  factory DiaryMemoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiaryMemoryRow(
      id: serializer.fromJson<int>(json['id']),
      creatureKey: serializer.fromJson<String>(json['creatureKey']),
      at: serializer.fromJson<DateTime>(json['at']),
      emoji: serializer.fromJson<String>(json['emoji']),
      title: serializer.fromJson<String>(json['title']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'creatureKey': serializer.toJson<String>(creatureKey),
      'at': serializer.toJson<DateTime>(at),
      'emoji': serializer.toJson<String>(emoji),
      'title': serializer.toJson<String>(title),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
    };
  }

  DiaryMemoryRow copyWith({
    int? id,
    String? creatureKey,
    DateTime? at,
    String? emoji,
    String? title,
    Value<double?> latitude = const Value.absent(),
    Value<double?> longitude = const Value.absent(),
  }) => DiaryMemoryRow(
    id: id ?? this.id,
    creatureKey: creatureKey ?? this.creatureKey,
    at: at ?? this.at,
    emoji: emoji ?? this.emoji,
    title: title ?? this.title,
    latitude: latitude.present ? latitude.value : this.latitude,
    longitude: longitude.present ? longitude.value : this.longitude,
  );
  DiaryMemoryRow copyWithCompanion(DiaryMemoriesCompanion data) {
    return DiaryMemoryRow(
      id: data.id.present ? data.id.value : this.id,
      creatureKey: data.creatureKey.present
          ? data.creatureKey.value
          : this.creatureKey,
      at: data.at.present ? data.at.value : this.at,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      title: data.title.present ? data.title.value : this.title,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiaryMemoryRow(')
          ..write('id: $id, ')
          ..write('creatureKey: $creatureKey, ')
          ..write('at: $at, ')
          ..write('emoji: $emoji, ')
          ..write('title: $title, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, creatureKey, at, emoji, title, latitude, longitude);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiaryMemoryRow &&
          other.id == this.id &&
          other.creatureKey == this.creatureKey &&
          other.at == this.at &&
          other.emoji == this.emoji &&
          other.title == this.title &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude);
}

class DiaryMemoriesCompanion extends UpdateCompanion<DiaryMemoryRow> {
  final Value<int> id;
  final Value<String> creatureKey;
  final Value<DateTime> at;
  final Value<String> emoji;
  final Value<String> title;
  final Value<double?> latitude;
  final Value<double?> longitude;
  const DiaryMemoriesCompanion({
    this.id = const Value.absent(),
    this.creatureKey = const Value.absent(),
    this.at = const Value.absent(),
    this.emoji = const Value.absent(),
    this.title = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
  });
  DiaryMemoriesCompanion.insert({
    this.id = const Value.absent(),
    required String creatureKey,
    required DateTime at,
    required String emoji,
    required String title,
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
  }) : creatureKey = Value(creatureKey),
       at = Value(at),
       emoji = Value(emoji),
       title = Value(title);
  static Insertable<DiaryMemoryRow> custom({
    Expression<int>? id,
    Expression<String>? creatureKey,
    Expression<DateTime>? at,
    Expression<String>? emoji,
    Expression<String>? title,
    Expression<double>? latitude,
    Expression<double>? longitude,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (creatureKey != null) 'creature_key': creatureKey,
      if (at != null) 'at': at,
      if (emoji != null) 'emoji': emoji,
      if (title != null) 'title': title,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    });
  }

  DiaryMemoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? creatureKey,
    Value<DateTime>? at,
    Value<String>? emoji,
    Value<String>? title,
    Value<double?>? latitude,
    Value<double?>? longitude,
  }) {
    return DiaryMemoriesCompanion(
      id: id ?? this.id,
      creatureKey: creatureKey ?? this.creatureKey,
      at: at ?? this.at,
      emoji: emoji ?? this.emoji,
      title: title ?? this.title,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (creatureKey.present) {
      map['creature_key'] = Variable<String>(creatureKey.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiaryMemoriesCompanion(')
          ..write('id: $id, ')
          ..write('creatureKey: $creatureKey, ')
          ..write('at: $at, ')
          ..write('emoji: $emoji, ')
          ..write('title: $title, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude')
          ..write(')'))
        .toString();
  }
}

class $ScentStatesTable extends ScentStates
    with TableInfo<$ScentStatesTable, ScentState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScentStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _environmentMeta = const VerificationMeta(
    'environment',
  );
  @override
  late final GeneratedColumn<String> environment = GeneratedColumn<String>(
    'environment',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    latitude,
    longitude,
    environment,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scent_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScentState> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('environment')) {
      context.handle(
        _environmentMeta,
        environment.isAcceptableOrUnknown(
          data['environment']!,
          _environmentMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScentState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScentState(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      environment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}environment'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ScentStatesTable createAlias(String alias) {
    return $ScentStatesTable(attachedDatabase, alias);
  }
}

class ScentState extends DataClass implements Insertable<ScentState> {
  final int id;
  final double latitude;
  final double longitude;

  /// Name der Umgebung (`EnvironmentType.name`), falls bekannt.
  final String? environment;
  final DateTime createdAt;
  const ScentState({
    required this.id,
    required this.latitude,
    required this.longitude,
    this.environment,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    if (!nullToAbsent || environment != null) {
      map['environment'] = Variable<String>(environment);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ScentStatesCompanion toCompanion(bool nullToAbsent) {
    return ScentStatesCompanion(
      id: Value(id),
      latitude: Value(latitude),
      longitude: Value(longitude),
      environment: environment == null && nullToAbsent
          ? const Value.absent()
          : Value(environment),
      createdAt: Value(createdAt),
    );
  }

  factory ScentState.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScentState(
      id: serializer.fromJson<int>(json['id']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      environment: serializer.fromJson<String?>(json['environment']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'environment': serializer.toJson<String?>(environment),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ScentState copyWith({
    int? id,
    double? latitude,
    double? longitude,
    Value<String?> environment = const Value.absent(),
    DateTime? createdAt,
  }) => ScentState(
    id: id ?? this.id,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    environment: environment.present ? environment.value : this.environment,
    createdAt: createdAt ?? this.createdAt,
  );
  ScentState copyWithCompanion(ScentStatesCompanion data) {
    return ScentState(
      id: data.id.present ? data.id.value : this.id,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      environment: data.environment.present
          ? data.environment.value
          : this.environment,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScentState(')
          ..write('id: $id, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('environment: $environment, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, latitude, longitude, environment, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScentState &&
          other.id == this.id &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.environment == this.environment &&
          other.createdAt == this.createdAt);
}

class ScentStatesCompanion extends UpdateCompanion<ScentState> {
  final Value<int> id;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<String?> environment;
  final Value<DateTime> createdAt;
  const ScentStatesCompanion({
    this.id = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.environment = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ScentStatesCompanion.insert({
    this.id = const Value.absent(),
    required double latitude,
    required double longitude,
    this.environment = const Value.absent(),
    required DateTime createdAt,
  }) : latitude = Value(latitude),
       longitude = Value(longitude),
       createdAt = Value(createdAt);
  static Insertable<ScentState> custom({
    Expression<int>? id,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? environment,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (environment != null) 'environment': environment,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ScentStatesCompanion copyWith({
    Value<int>? id,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<String?>? environment,
    Value<DateTime>? createdAt,
  }) {
    return ScentStatesCompanion(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      environment: environment ?? this.environment,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (environment.present) {
      map['environment'] = Variable<String>(environment.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScentStatesCompanion(')
          ..write('id: $id, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('environment: $environment, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PreferencesTable extends Preferences
    with TableInfo<$PreferencesTable, Preference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'preferences';
  @override
  VerificationContext validateIntegrity(
    Insertable<Preference> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Preference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Preference(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $PreferencesTable createAlias(String alias) {
    return $PreferencesTable(attachedDatabase, alias);
  }
}

class Preference extends DataClass implements Insertable<Preference> {
  final String key;
  final String value;
  const Preference({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  PreferencesCompanion toCompanion(bool nullToAbsent) {
    return PreferencesCompanion(key: Value(key), value: Value(value));
  }

  factory Preference.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Preference(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Preference copyWith({String? key, String? value}) =>
      Preference(key: key ?? this.key, value: value ?? this.value);
  Preference copyWithCompanion(PreferencesCompanion data) {
    return Preference(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Preference(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Preference &&
          other.key == this.key &&
          other.value == this.value);
}

class PreferencesCompanion extends UpdateCompanion<Preference> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const PreferencesCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PreferencesCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<Preference> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PreferencesCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return PreferencesCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreferencesCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
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
  late final $TreasureStatesTable treasureStates = $TreasureStatesTable(this);
  late final $AdventureStatesTable adventureStates = $AdventureStatesTable(
    this,
  );
  late final $FriendshipStatesTable friendshipStates = $FriendshipStatesTable(
    this,
  );
  late final $DiaryWalksTable diaryWalks = $DiaryWalksTable(this);
  late final $DiaryMemoriesTable diaryMemories = $DiaryMemoriesTable(this);
  late final $ScentStatesTable scentStates = $ScentStatesTable(this);
  late final $PreferencesTable preferences = $PreferencesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    creatureStates,
    knownSegments,
    recordedWalks,
    walkSummaries,
    treasureStates,
    adventureStates,
    friendshipStates,
    diaryWalks,
    diaryMemories,
    scentStates,
    preferences,
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
      Value<String?> hat,
      Value<String?> neck,
      Value<String> seenSpecies,
      Value<bool> luckyEgg,
      Value<int> walkedMeters,
    });
typedef $$CreatureStatesTableUpdateCompanionBuilder =
    CreatureStatesCompanion Function({
      Value<int> id,
      Value<int> food,
      Value<String> traitPoints,
      Value<DateTime?> lastFedAt,
      Value<String?> speciesId,
      Value<DateTime?> lastReleasedAt,
      Value<String?> hat,
      Value<String?> neck,
      Value<String> seenSpecies,
      Value<bool> luckyEgg,
      Value<int> walkedMeters,
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

  ColumnFilters<String> get hat => $composableBuilder(
    column: $table.hat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get neck => $composableBuilder(
    column: $table.neck,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seenSpecies => $composableBuilder(
    column: $table.seenSpecies,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get luckyEgg => $composableBuilder(
    column: $table.luckyEgg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get walkedMeters => $composableBuilder(
    column: $table.walkedMeters,
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

  ColumnOrderings<String> get hat => $composableBuilder(
    column: $table.hat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get neck => $composableBuilder(
    column: $table.neck,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seenSpecies => $composableBuilder(
    column: $table.seenSpecies,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get luckyEgg => $composableBuilder(
    column: $table.luckyEgg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get walkedMeters => $composableBuilder(
    column: $table.walkedMeters,
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

  GeneratedColumn<String> get hat =>
      $composableBuilder(column: $table.hat, builder: (column) => column);

  GeneratedColumn<String> get neck =>
      $composableBuilder(column: $table.neck, builder: (column) => column);

  GeneratedColumn<String> get seenSpecies => $composableBuilder(
    column: $table.seenSpecies,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get luckyEgg =>
      $composableBuilder(column: $table.luckyEgg, builder: (column) => column);

  GeneratedColumn<int> get walkedMeters => $composableBuilder(
    column: $table.walkedMeters,
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
                Value<String?> hat = const Value.absent(),
                Value<String?> neck = const Value.absent(),
                Value<String> seenSpecies = const Value.absent(),
                Value<bool> luckyEgg = const Value.absent(),
                Value<int> walkedMeters = const Value.absent(),
              }) => CreatureStatesCompanion(
                id: id,
                food: food,
                traitPoints: traitPoints,
                lastFedAt: lastFedAt,
                speciesId: speciesId,
                lastReleasedAt: lastReleasedAt,
                hat: hat,
                neck: neck,
                seenSpecies: seenSpecies,
                luckyEgg: luckyEgg,
                walkedMeters: walkedMeters,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> food = const Value.absent(),
                Value<String> traitPoints = const Value.absent(),
                Value<DateTime?> lastFedAt = const Value.absent(),
                Value<String?> speciesId = const Value.absent(),
                Value<DateTime?> lastReleasedAt = const Value.absent(),
                Value<String?> hat = const Value.absent(),
                Value<String?> neck = const Value.absent(),
                Value<String> seenSpecies = const Value.absent(),
                Value<bool> luckyEgg = const Value.absent(),
                Value<int> walkedMeters = const Value.absent(),
              }) => CreatureStatesCompanion.insert(
                id: id,
                food: food,
                traitPoints: traitPoints,
                lastFedAt: lastFedAt,
                speciesId: speciesId,
                lastReleasedAt: lastReleasedAt,
                hat: hat,
                neck: neck,
                seenSpecies: seenSpecies,
                luckyEgg: luckyEgg,
                walkedMeters: walkedMeters,
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
      Value<String> extraLines,
      Value<int> distanceMeters,
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
      Value<String> extraLines,
      Value<int> distanceMeters,
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

  ColumnFilters<String> get extraLines => $composableBuilder(
    column: $table.extraLines,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
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

  ColumnOrderings<String> get extraLines => $composableBuilder(
    column: $table.extraLines,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
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

  GeneratedColumn<String> get extraLines => $composableBuilder(
    column: $table.extraLines,
    builder: (column) => column,
  );

  GeneratedColumn<int> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => column,
  );
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
                Value<String> extraLines = const Value.absent(),
                Value<int> distanceMeters = const Value.absent(),
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
                extraLines: extraLines,
                distanceMeters: distanceMeters,
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
                Value<String> extraLines = const Value.absent(),
                Value<int> distanceMeters = const Value.absent(),
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
                extraLines: extraLines,
                distanceMeters: distanceMeters,
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
typedef $$TreasureStatesTableCreateCompanionBuilder =
    TreasureStatesCompanion Function({
      Value<int> id,
      Value<String> finds,
      Value<String> owned,
    });
typedef $$TreasureStatesTableUpdateCompanionBuilder =
    TreasureStatesCompanion Function({
      Value<int> id,
      Value<String> finds,
      Value<String> owned,
    });

class $$TreasureStatesTableFilterComposer
    extends Composer<_$AppDatabase, $TreasureStatesTable> {
  $$TreasureStatesTableFilterComposer({
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

  ColumnFilters<String> get finds => $composableBuilder(
    column: $table.finds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get owned => $composableBuilder(
    column: $table.owned,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TreasureStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $TreasureStatesTable> {
  $$TreasureStatesTableOrderingComposer({
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

  ColumnOrderings<String> get finds => $composableBuilder(
    column: $table.finds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get owned => $composableBuilder(
    column: $table.owned,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TreasureStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TreasureStatesTable> {
  $$TreasureStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get finds =>
      $composableBuilder(column: $table.finds, builder: (column) => column);

  GeneratedColumn<String> get owned =>
      $composableBuilder(column: $table.owned, builder: (column) => column);
}

class $$TreasureStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TreasureStatesTable,
          TreasureState,
          $$TreasureStatesTableFilterComposer,
          $$TreasureStatesTableOrderingComposer,
          $$TreasureStatesTableAnnotationComposer,
          $$TreasureStatesTableCreateCompanionBuilder,
          $$TreasureStatesTableUpdateCompanionBuilder,
          (
            TreasureState,
            BaseReferences<_$AppDatabase, $TreasureStatesTable, TreasureState>,
          ),
          TreasureState,
          PrefetchHooks Function()
        > {
  $$TreasureStatesTableTableManager(
    _$AppDatabase db,
    $TreasureStatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TreasureStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TreasureStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TreasureStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> finds = const Value.absent(),
                Value<String> owned = const Value.absent(),
              }) => TreasureStatesCompanion(id: id, finds: finds, owned: owned),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> finds = const Value.absent(),
                Value<String> owned = const Value.absent(),
              }) => TreasureStatesCompanion.insert(
                id: id,
                finds: finds,
                owned: owned,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TreasureStatesTable, TreasureState>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $TreasureStatesTable,
                    TreasureState
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TreasureStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TreasureStatesTable,
      TreasureState,
      $$TreasureStatesTableFilterComposer,
      $$TreasureStatesTableOrderingComposer,
      $$TreasureStatesTableAnnotationComposer,
      $$TreasureStatesTableCreateCompanionBuilder,
      $$TreasureStatesTableUpdateCompanionBuilder,
      (
        TreasureState,
        BaseReferences<_$AppDatabase, $TreasureStatesTable, TreasureState>,
      ),
      TreasureState,
      PrefetchHooks Function()
    >;
typedef $$AdventureStatesTableCreateCompanionBuilder =
    AdventureStatesCompanion Function({
      Value<int> id,
      required DateTime weekStart,
      required String quests,
      Value<bool> bonusClaimed,
    });
typedef $$AdventureStatesTableUpdateCompanionBuilder =
    AdventureStatesCompanion Function({
      Value<int> id,
      Value<DateTime> weekStart,
      Value<String> quests,
      Value<bool> bonusClaimed,
    });

class $$AdventureStatesTableFilterComposer
    extends Composer<_$AppDatabase, $AdventureStatesTable> {
  $$AdventureStatesTableFilterComposer({
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

  ColumnFilters<DateTime> get weekStart => $composableBuilder(
    column: $table.weekStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quests => $composableBuilder(
    column: $table.quests,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get bonusClaimed => $composableBuilder(
    column: $table.bonusClaimed,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AdventureStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $AdventureStatesTable> {
  $$AdventureStatesTableOrderingComposer({
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

  ColumnOrderings<DateTime> get weekStart => $composableBuilder(
    column: $table.weekStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quests => $composableBuilder(
    column: $table.quests,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get bonusClaimed => $composableBuilder(
    column: $table.bonusClaimed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AdventureStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AdventureStatesTable> {
  $$AdventureStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get weekStart =>
      $composableBuilder(column: $table.weekStart, builder: (column) => column);

  GeneratedColumn<String> get quests =>
      $composableBuilder(column: $table.quests, builder: (column) => column);

  GeneratedColumn<bool> get bonusClaimed => $composableBuilder(
    column: $table.bonusClaimed,
    builder: (column) => column,
  );
}

class $$AdventureStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AdventureStatesTable,
          AdventureState,
          $$AdventureStatesTableFilterComposer,
          $$AdventureStatesTableOrderingComposer,
          $$AdventureStatesTableAnnotationComposer,
          $$AdventureStatesTableCreateCompanionBuilder,
          $$AdventureStatesTableUpdateCompanionBuilder,
          (
            AdventureState,
            BaseReferences<
              _$AppDatabase,
              $AdventureStatesTable,
              AdventureState
            >,
          ),
          AdventureState,
          PrefetchHooks Function()
        > {
  $$AdventureStatesTableTableManager(
    _$AppDatabase db,
    $AdventureStatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AdventureStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AdventureStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AdventureStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> weekStart = const Value.absent(),
                Value<String> quests = const Value.absent(),
                Value<bool> bonusClaimed = const Value.absent(),
              }) => AdventureStatesCompanion(
                id: id,
                weekStart: weekStart,
                quests: quests,
                bonusClaimed: bonusClaimed,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime weekStart,
                required String quests,
                Value<bool> bonusClaimed = const Value.absent(),
              }) => AdventureStatesCompanion.insert(
                id: id,
                weekStart: weekStart,
                quests: quests,
                bonusClaimed: bonusClaimed,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AdventureStatesTable, AdventureState>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AdventureStatesTable,
                    AdventureState
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AdventureStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AdventureStatesTable,
      AdventureState,
      $$AdventureStatesTableFilterComposer,
      $$AdventureStatesTableOrderingComposer,
      $$AdventureStatesTableAnnotationComposer,
      $$AdventureStatesTableCreateCompanionBuilder,
      $$AdventureStatesTableUpdateCompanionBuilder,
      (
        AdventureState,
        BaseReferences<_$AppDatabase, $AdventureStatesTable, AdventureState>,
      ),
      AdventureState,
      PrefetchHooks Function()
    >;
typedef $$FriendshipStatesTableCreateCompanionBuilder =
    FriendshipStatesCompanion Function({
      Value<int> id,
      required String creatureKey,
      Value<int> points,
      Value<int> petsToday,
      Value<DateTime?> petDay,
    });
typedef $$FriendshipStatesTableUpdateCompanionBuilder =
    FriendshipStatesCompanion Function({
      Value<int> id,
      Value<String> creatureKey,
      Value<int> points,
      Value<int> petsToday,
      Value<DateTime?> petDay,
    });

class $$FriendshipStatesTableFilterComposer
    extends Composer<_$AppDatabase, $FriendshipStatesTable> {
  $$FriendshipStatesTableFilterComposer({
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

  ColumnFilters<String> get creatureKey => $composableBuilder(
    column: $table.creatureKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get petsToday => $composableBuilder(
    column: $table.petsToday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get petDay => $composableBuilder(
    column: $table.petDay,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FriendshipStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $FriendshipStatesTable> {
  $$FriendshipStatesTableOrderingComposer({
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

  ColumnOrderings<String> get creatureKey => $composableBuilder(
    column: $table.creatureKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get petsToday => $composableBuilder(
    column: $table.petsToday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get petDay => $composableBuilder(
    column: $table.petDay,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FriendshipStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FriendshipStatesTable> {
  $$FriendshipStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get creatureKey => $composableBuilder(
    column: $table.creatureKey,
    builder: (column) => column,
  );

  GeneratedColumn<int> get points =>
      $composableBuilder(column: $table.points, builder: (column) => column);

  GeneratedColumn<int> get petsToday =>
      $composableBuilder(column: $table.petsToday, builder: (column) => column);

  GeneratedColumn<DateTime> get petDay =>
      $composableBuilder(column: $table.petDay, builder: (column) => column);
}

class $$FriendshipStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FriendshipStatesTable,
          FriendshipState,
          $$FriendshipStatesTableFilterComposer,
          $$FriendshipStatesTableOrderingComposer,
          $$FriendshipStatesTableAnnotationComposer,
          $$FriendshipStatesTableCreateCompanionBuilder,
          $$FriendshipStatesTableUpdateCompanionBuilder,
          (
            FriendshipState,
            BaseReferences<
              _$AppDatabase,
              $FriendshipStatesTable,
              FriendshipState
            >,
          ),
          FriendshipState,
          PrefetchHooks Function()
        > {
  $$FriendshipStatesTableTableManager(
    _$AppDatabase db,
    $FriendshipStatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FriendshipStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FriendshipStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FriendshipStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> creatureKey = const Value.absent(),
                Value<int> points = const Value.absent(),
                Value<int> petsToday = const Value.absent(),
                Value<DateTime?> petDay = const Value.absent(),
              }) => FriendshipStatesCompanion(
                id: id,
                creatureKey: creatureKey,
                points: points,
                petsToday: petsToday,
                petDay: petDay,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String creatureKey,
                Value<int> points = const Value.absent(),
                Value<int> petsToday = const Value.absent(),
                Value<DateTime?> petDay = const Value.absent(),
              }) => FriendshipStatesCompanion.insert(
                id: id,
                creatureKey: creatureKey,
                points: points,
                petsToday: petsToday,
                petDay: petDay,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FriendshipStatesTable, FriendshipState>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $FriendshipStatesTable,
                    FriendshipState
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FriendshipStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FriendshipStatesTable,
      FriendshipState,
      $$FriendshipStatesTableFilterComposer,
      $$FriendshipStatesTableOrderingComposer,
      $$FriendshipStatesTableAnnotationComposer,
      $$FriendshipStatesTableCreateCompanionBuilder,
      $$FriendshipStatesTableUpdateCompanionBuilder,
      (
        FriendshipState,
        BaseReferences<_$AppDatabase, $FriendshipStatesTable, FriendshipState>,
      ),
      FriendshipState,
      PrefetchHooks Function()
    >;
typedef $$DiaryWalksTableCreateCompanionBuilder =
    DiaryWalksCompanion Function({
      required String walkId,
      required String creatureKey,
      required DateTime finishedAt,
      required int meters,
      required String path,
      Value<int> rowid,
    });
typedef $$DiaryWalksTableUpdateCompanionBuilder =
    DiaryWalksCompanion Function({
      Value<String> walkId,
      Value<String> creatureKey,
      Value<DateTime> finishedAt,
      Value<int> meters,
      Value<String> path,
      Value<int> rowid,
    });

class $$DiaryWalksTableFilterComposer
    extends Composer<_$AppDatabase, $DiaryWalksTable> {
  $$DiaryWalksTableFilterComposer({
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

  ColumnFilters<String> get creatureKey => $composableBuilder(
    column: $table.creatureKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get meters => $composableBuilder(
    column: $table.meters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DiaryWalksTableOrderingComposer
    extends Composer<_$AppDatabase, $DiaryWalksTable> {
  $$DiaryWalksTableOrderingComposer({
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

  ColumnOrderings<String> get creatureKey => $composableBuilder(
    column: $table.creatureKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get meters => $composableBuilder(
    column: $table.meters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DiaryWalksTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiaryWalksTable> {
  $$DiaryWalksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get walkId =>
      $composableBuilder(column: $table.walkId, builder: (column) => column);

  GeneratedColumn<String> get creatureKey => $composableBuilder(
    column: $table.creatureKey,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get meters =>
      $composableBuilder(column: $table.meters, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);
}

class $$DiaryWalksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DiaryWalksTable,
          DiaryWalkRow,
          $$DiaryWalksTableFilterComposer,
          $$DiaryWalksTableOrderingComposer,
          $$DiaryWalksTableAnnotationComposer,
          $$DiaryWalksTableCreateCompanionBuilder,
          $$DiaryWalksTableUpdateCompanionBuilder,
          (
            DiaryWalkRow,
            BaseReferences<_$AppDatabase, $DiaryWalksTable, DiaryWalkRow>,
          ),
          DiaryWalkRow,
          PrefetchHooks Function()
        > {
  $$DiaryWalksTableTableManager(_$AppDatabase db, $DiaryWalksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiaryWalksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiaryWalksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiaryWalksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> walkId = const Value.absent(),
                Value<String> creatureKey = const Value.absent(),
                Value<DateTime> finishedAt = const Value.absent(),
                Value<int> meters = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DiaryWalksCompanion(
                walkId: walkId,
                creatureKey: creatureKey,
                finishedAt: finishedAt,
                meters: meters,
                path: path,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String walkId,
                required String creatureKey,
                required DateTime finishedAt,
                required int meters,
                required String path,
                Value<int> rowid = const Value.absent(),
              }) => DiaryWalksCompanion.insert(
                walkId: walkId,
                creatureKey: creatureKey,
                finishedAt: finishedAt,
                meters: meters,
                path: path,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DiaryWalksTable, DiaryWalkRow>(table),
                  BaseReferences<_$AppDatabase, $DiaryWalksTable, DiaryWalkRow>(
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

typedef $$DiaryWalksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DiaryWalksTable,
      DiaryWalkRow,
      $$DiaryWalksTableFilterComposer,
      $$DiaryWalksTableOrderingComposer,
      $$DiaryWalksTableAnnotationComposer,
      $$DiaryWalksTableCreateCompanionBuilder,
      $$DiaryWalksTableUpdateCompanionBuilder,
      (
        DiaryWalkRow,
        BaseReferences<_$AppDatabase, $DiaryWalksTable, DiaryWalkRow>,
      ),
      DiaryWalkRow,
      PrefetchHooks Function()
    >;
typedef $$DiaryMemoriesTableCreateCompanionBuilder =
    DiaryMemoriesCompanion Function({
      Value<int> id,
      required String creatureKey,
      required DateTime at,
      required String emoji,
      required String title,
      Value<double?> latitude,
      Value<double?> longitude,
    });
typedef $$DiaryMemoriesTableUpdateCompanionBuilder =
    DiaryMemoriesCompanion Function({
      Value<int> id,
      Value<String> creatureKey,
      Value<DateTime> at,
      Value<String> emoji,
      Value<String> title,
      Value<double?> latitude,
      Value<double?> longitude,
    });

class $$DiaryMemoriesTableFilterComposer
    extends Composer<_$AppDatabase, $DiaryMemoriesTable> {
  $$DiaryMemoriesTableFilterComposer({
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

  ColumnFilters<String> get creatureKey => $composableBuilder(
    column: $table.creatureKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DiaryMemoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $DiaryMemoriesTable> {
  $$DiaryMemoriesTableOrderingComposer({
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

  ColumnOrderings<String> get creatureKey => $composableBuilder(
    column: $table.creatureKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DiaryMemoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiaryMemoriesTable> {
  $$DiaryMemoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get creatureKey => $composableBuilder(
    column: $table.creatureKey,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);
}

class $$DiaryMemoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DiaryMemoriesTable,
          DiaryMemoryRow,
          $$DiaryMemoriesTableFilterComposer,
          $$DiaryMemoriesTableOrderingComposer,
          $$DiaryMemoriesTableAnnotationComposer,
          $$DiaryMemoriesTableCreateCompanionBuilder,
          $$DiaryMemoriesTableUpdateCompanionBuilder,
          (
            DiaryMemoryRow,
            BaseReferences<_$AppDatabase, $DiaryMemoriesTable, DiaryMemoryRow>,
          ),
          DiaryMemoryRow,
          PrefetchHooks Function()
        > {
  $$DiaryMemoriesTableTableManager(_$AppDatabase db, $DiaryMemoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiaryMemoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiaryMemoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiaryMemoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> creatureKey = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
                Value<String> emoji = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
              }) => DiaryMemoriesCompanion(
                id: id,
                creatureKey: creatureKey,
                at: at,
                emoji: emoji,
                title: title,
                latitude: latitude,
                longitude: longitude,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String creatureKey,
                required DateTime at,
                required String emoji,
                required String title,
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
              }) => DiaryMemoriesCompanion.insert(
                id: id,
                creatureKey: creatureKey,
                at: at,
                emoji: emoji,
                title: title,
                latitude: latitude,
                longitude: longitude,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DiaryMemoriesTable, DiaryMemoryRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $DiaryMemoriesTable,
                    DiaryMemoryRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DiaryMemoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DiaryMemoriesTable,
      DiaryMemoryRow,
      $$DiaryMemoriesTableFilterComposer,
      $$DiaryMemoriesTableOrderingComposer,
      $$DiaryMemoriesTableAnnotationComposer,
      $$DiaryMemoriesTableCreateCompanionBuilder,
      $$DiaryMemoriesTableUpdateCompanionBuilder,
      (
        DiaryMemoryRow,
        BaseReferences<_$AppDatabase, $DiaryMemoriesTable, DiaryMemoryRow>,
      ),
      DiaryMemoryRow,
      PrefetchHooks Function()
    >;
typedef $$ScentStatesTableCreateCompanionBuilder =
    ScentStatesCompanion Function({
      Value<int> id,
      required double latitude,
      required double longitude,
      Value<String?> environment,
      required DateTime createdAt,
    });
typedef $$ScentStatesTableUpdateCompanionBuilder =
    ScentStatesCompanion Function({
      Value<int> id,
      Value<double> latitude,
      Value<double> longitude,
      Value<String?> environment,
      Value<DateTime> createdAt,
    });

class $$ScentStatesTableFilterComposer
    extends Composer<_$AppDatabase, $ScentStatesTable> {
  $$ScentStatesTableFilterComposer({
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

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get environment => $composableBuilder(
    column: $table.environment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ScentStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $ScentStatesTable> {
  $$ScentStatesTableOrderingComposer({
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

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get environment => $composableBuilder(
    column: $table.environment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ScentStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScentStatesTable> {
  $$ScentStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get environment => $composableBuilder(
    column: $table.environment,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ScentStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScentStatesTable,
          ScentState,
          $$ScentStatesTableFilterComposer,
          $$ScentStatesTableOrderingComposer,
          $$ScentStatesTableAnnotationComposer,
          $$ScentStatesTableCreateCompanionBuilder,
          $$ScentStatesTableUpdateCompanionBuilder,
          (
            ScentState,
            BaseReferences<_$AppDatabase, $ScentStatesTable, ScentState>,
          ),
          ScentState,
          PrefetchHooks Function()
        > {
  $$ScentStatesTableTableManager(_$AppDatabase db, $ScentStatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScentStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScentStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScentStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<String?> environment = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ScentStatesCompanion(
                id: id,
                latitude: latitude,
                longitude: longitude,
                environment: environment,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required double latitude,
                required double longitude,
                Value<String?> environment = const Value.absent(),
                required DateTime createdAt,
              }) => ScentStatesCompanion.insert(
                id: id,
                latitude: latitude,
                longitude: longitude,
                environment: environment,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ScentStatesTable, ScentState>(table),
                  BaseReferences<_$AppDatabase, $ScentStatesTable, ScentState>(
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

typedef $$ScentStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScentStatesTable,
      ScentState,
      $$ScentStatesTableFilterComposer,
      $$ScentStatesTableOrderingComposer,
      $$ScentStatesTableAnnotationComposer,
      $$ScentStatesTableCreateCompanionBuilder,
      $$ScentStatesTableUpdateCompanionBuilder,
      (
        ScentState,
        BaseReferences<_$AppDatabase, $ScentStatesTable, ScentState>,
      ),
      ScentState,
      PrefetchHooks Function()
    >;
typedef $$PreferencesTableCreateCompanionBuilder =
    PreferencesCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$PreferencesTableUpdateCompanionBuilder =
    PreferencesCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$PreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $PreferencesTable> {
  $$PreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $PreferencesTable> {
  $$PreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PreferencesTable> {
  $$PreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$PreferencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PreferencesTable,
          Preference,
          $$PreferencesTableFilterComposer,
          $$PreferencesTableOrderingComposer,
          $$PreferencesTableAnnotationComposer,
          $$PreferencesTableCreateCompanionBuilder,
          $$PreferencesTableUpdateCompanionBuilder,
          (
            Preference,
            BaseReferences<_$AppDatabase, $PreferencesTable, Preference>,
          ),
          Preference,
          PrefetchHooks Function()
        > {
  $$PreferencesTableTableManager(_$AppDatabase db, $PreferencesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PreferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PreferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PreferencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PreferencesCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => PreferencesCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PreferencesTable, Preference>(table),
                  BaseReferences<_$AppDatabase, $PreferencesTable, Preference>(
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

typedef $$PreferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PreferencesTable,
      Preference,
      $$PreferencesTableFilterComposer,
      $$PreferencesTableOrderingComposer,
      $$PreferencesTableAnnotationComposer,
      $$PreferencesTableCreateCompanionBuilder,
      $$PreferencesTableUpdateCompanionBuilder,
      (
        Preference,
        BaseReferences<_$AppDatabase, $PreferencesTable, Preference>,
      ),
      Preference,
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
  $$TreasureStatesTableTableManager get treasureStates =>
      $$TreasureStatesTableTableManager(_db, _db.treasureStates);
  $$AdventureStatesTableTableManager get adventureStates =>
      $$AdventureStatesTableTableManager(_db, _db.adventureStates);
  $$FriendshipStatesTableTableManager get friendshipStates =>
      $$FriendshipStatesTableTableManager(_db, _db.friendshipStates);
  $$DiaryWalksTableTableManager get diaryWalks =>
      $$DiaryWalksTableTableManager(_db, _db.diaryWalks);
  $$DiaryMemoriesTableTableManager get diaryMemories =>
      $$DiaryMemoriesTableTableManager(_db, _db.diaryMemories);
  $$ScentStatesTableTableManager get scentStates =>
      $$ScentStatesTableTableManager(_db, _db.scentStates);
  $$PreferencesTableTableManager get preferences =>
      $$PreferencesTableTableManager(_db, _db.preferences);
}
