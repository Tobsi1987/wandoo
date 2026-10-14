import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:wandoo/core/database/bond_tables.dart';
import 'package:wandoo/core/database/play_tables.dart';
import 'package:wandoo/core/database/tables.dart';

part 'app_database.g.dart';

/// Lokale Datenbank. Alle Daten bleiben auf dem Gerät.
///
/// Das Schema liegt hier zentral, damit `core` keine Features kennen muss.
/// Die Übersetzung in Domänenobjekte machen die Repositories in den
/// `data/`-Ordnern der Features.
@DriftDatabase(
  tables: [
    CreatureStates,
    KnownSegments,
    RecordedWalks,
    WalkSummaries,
    TreasureStates,
    AdventureStates,
    FriendshipStates,
    DiaryWalks,
    DiaryMemories,
    ScentStates,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  /// Öffnet die Datenbankdatei der App.
  factory AppDatabase.open() => AppDatabase(driftDatabase(name: 'wandoo'));

  @override
  int get schemaVersion => 11;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) await m.createTable(recordedWalks);
      if (from < 3) await m.createTable(walkSummaries);
      if (from >= 3 && from < 4) {
        await m.addColumn(walkSummaries, walkSummaries.knownSegmentCount);
      }
      if (from < 5) {
        await m.addColumn(creatureStates, creatureStates.speciesId);
        await m.addColumn(creatureStates, creatureStates.lastReleasedAt);
      }
      if (from >= 2 && from < 6) {
        await m.addColumn(recordedWalks, recordedWalks.finished);
      }
      if (from < 7) await _upgradeTo7(m, from);
      if (from < 8) await m.createTable(adventureStates);
      if (from < 9) await _upgradeTo9(m, from);
      if (from < 10) {
        await m.createTable(friendshipStates);
        await m.createTable(diaryWalks);
        await m.createTable(diaryMemories);
      }
      if (from < 11) await m.createTable(scentStates);
    },
  );

  Future<void> _upgradeTo9(Migrator m, int from) async {
    await m.addColumn(creatureStates, creatureStates.walkedMeters);
    if (from >= 3) {
      await m.addColumn(walkSummaries, walkSummaries.distanceMeters);
    }
  }

  Future<void> _upgradeTo7(Migrator m, int from) async {
    for (final column in [
      creatureStates.hat,
      creatureStates.neck,
      creatureStates.seenSpecies,
      creatureStates.luckyEgg,
    ]) {
      await m.addColumn(creatureStates, column);
    }
    if (from >= 3) {
      await m.addColumn(walkSummaries, walkSummaries.extraLines);
    }
    await m.createTable(treasureStates);
  }
}
