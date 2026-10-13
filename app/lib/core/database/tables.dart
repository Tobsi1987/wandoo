import 'package:drift/drift.dart';

/// Zustand des Wesens. Genau eine Zeile (id = 1).
class CreatureStates extends Table {
  IntColumn get id => integer()();
  IntColumn get food => integer().withDefault(const Constant(0))();

  /// Merkmalspunkte als JSON, z. B. `{"moss":3}`.
  TextColumn get traitPoints => text().withDefault(const Constant('{}'))();
  DateTimeColumn get lastFedAt => dateTime().nullable()();

  /// `Species.id`, gezogen beim Schlüpfen (seit Schema 5).
  TextColumn get speciesId => text().nullable()();
  DateTimeColumn get lastReleasedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Alle schon entdeckten Straßenabschnitte.
class KnownSegments extends Table {
  TextColumn get segmentId => text()();
  DateTimeColumn get discoveredAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {segmentId};
}

/// Aufgezeichnete Gänge als GPX, bis sie verarbeitet sind.
class RecordedWalks extends Table {
  TextColumn get id => text()();
  DateTimeColumn get startedAt => dateTime()();
  TextColumn get gpx => text()();
  DateTimeColumn get processedAt => dateTime().nullable()();

  /// false, solange der Gang noch läuft und nur zwischengesichert ist.
  BoolColumn get finished => boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Zusammenfassung je verarbeitetem Gang.
@DataClassName('WalkSummaryRow')
class WalkSummaries extends Table {
  TextColumn get walkId => text()();
  DateTimeColumn get finishedAt => dateTime()();
  IntColumn get newSegmentCount => integer()();
  IntColumn get newStreetCount => integer()();
  IntColumn get bridgeCount => integer()();

  /// Wieder abgelaufene bekannte Abschnitte (seit Schema 4).
  IntColumn get knownSegmentCount => integer().withDefault(const Constant(0))();

  /// Neue Straßen je Umgebung als JSON, z. B. `{"forest":2}`.
  TextColumn get streetsByEnvironment => text()();
  BoolColumn get creatureGrew => boolean()();
  BoolColumn get seen => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {walkId};
}
