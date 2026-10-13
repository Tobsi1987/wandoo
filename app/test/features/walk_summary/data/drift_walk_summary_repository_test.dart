import 'package:flutter_test/flutter_test.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/walk_summary/data/drift_walk_summary_repository.dart';
import 'package:wandoo/features/walk_summary/walk_summary.dart';

import '../../../support/test_database.dart';

WalkSummary summary(String id, int day) => WalkSummary(
  walkId: id,
  finishedAt: DateTime(2026, 10, day),
  newSegmentCount: 3,
  newStreetCount: 2,
  streetsByEnvironment: const {EnvironmentType.forest: 2},
  bridgeCount: 0,
  creatureGrew: false,
);

void main() {
  test('zeigt die neueste ungesehene Zusammenfassung', () async {
    final db = testDatabase();
    addTearDown(db.close);
    final repo = DriftWalkSummaryRepository(db);
    await repo.save(summary('alt', 1));
    await repo.save(summary('neu', 2));

    final latest = await repo.watchLatestUnseen().first;
    expect(latest?.walkId, 'neu');
    expect(latest?.streetsByEnvironment, {EnvironmentType.forest: 2});

    await repo.markSeen('neu');
    expect((await repo.watchLatestUnseen().first)?.walkId, 'alt');
    await repo.markSeen('alt');
    expect(await repo.watchLatestUnseen().first, isNull);
  });
}
