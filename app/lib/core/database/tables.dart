import 'package:drift/drift.dart';

/// Zustand des Wesens. Genau eine Zeile (id = 1).
class CreatureStates extends Table {
  IntColumn get id => integer()();
  IntColumn get food => integer().withDefault(const Constant(0))();

  /// Merkmalspunkte als JSON, z. B. `{"moss":3}`.
  TextColumn get traitPoints => text().withDefault(const Constant('{}'))();
  DateTimeColumn get lastFedAt => dateTime().nullable()();

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

  @override
  Set<Column<Object>> get primaryKey => {id};
}
