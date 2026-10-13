import 'package:drift/drift.dart';

/// Freundschaft zum aktuellen Wesen, genau eine Zeile (seit Schema 10).
class FriendshipStates extends Table {
  IntColumn get id => integer()();

  /// Zu welchem Wesen die Punkte gehören (`Creature.lineKey`).
  TextColumn get creatureKey => text()();
  IntColumn get points => integer().withDefault(const Constant(0))();
  IntColumn get petsToday => integer().withDefault(const Constant(0))();
  DateTimeColumn get petDay => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Ein Gang im Tagebuch eines Wesens (seit Schema 10).
@DataClassName('DiaryWalkRow')
class DiaryWalks extends Table {
  TextColumn get walkId => text()();
  TextColumn get creatureKey => text()();
  DateTimeColumn get finishedAt => dateTime()();
  IntColumn get meters => integer()();

  /// Ausgedünnte Spur als JSON, z. B. `[[52.1,7.6],[52.2,7.6]]`.
  TextColumn get path => text()();

  @override
  Set<Column<Object>> get primaryKey => {walkId};
}

/// Eine Erinnerung im Tagebuch, zum Beispiel das Schlüpfen.
@DataClassName('DiaryMemoryRow')
class DiaryMemories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get creatureKey => text()();
  DateTimeColumn get at => dateTime()();
  TextColumn get emoji => text()();
  TextColumn get title => text()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
}
