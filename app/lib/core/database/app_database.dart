import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:wandoo/core/database/tables.dart';

part 'app_database.g.dart';

/// Lokale Datenbank. Alle Daten bleiben auf dem Gerät.
///
/// Das Schema liegt hier zentral, damit `core` keine Features kennen muss.
/// Die Übersetzung in Domänenobjekte machen die Repositories in den
/// `data/`-Ordnern der Features.
@DriftDatabase(
  tables: [CreatureStates, KnownSegments, RecordedWalks, WalkSummaries],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  /// Öffnet die Datenbankdatei der App.
  factory AppDatabase.open() => AppDatabase(driftDatabase(name: 'wandoo'));

  @override
  int get schemaVersion => 6;

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
    },
  );
}
