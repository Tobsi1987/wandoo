import 'package:flutter_test/flutter_test.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/tracking/data/drift_recorded_walk_repository.dart';

import '../../../support/fake_location_source.dart';
import '../../../support/test_database.dart';

void main() {
  test('offene Gänge bleiben, bis sie verarbeitet sind', () async {
    final db = testDatabase();
    addTearDown(db.close);
    final repo = DriftRecordedWalkRepository(db);
    final track = Track(id: 'gang', points: [eastOf(0, 0), eastOf(50, 40)]);

    await repo.saveFinished(track);
    final pending = await repo.pending();
    expect(pending.single.id, 'gang');
    expect(pending.single.positions, hasLength(2));
    expect(await repo.watchPendingCount().first, 1);

    await repo.markProcessed('gang');
    expect(await repo.pending(), isEmpty);
    expect(await repo.watchPendingCount().first, 0);
  });
}
