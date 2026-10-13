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
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) await m.createTable(recordedWalks);
      if (from < 3) await m.createTable(walkSummaries);
    },
  );
}
