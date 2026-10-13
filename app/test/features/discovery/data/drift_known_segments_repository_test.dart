import 'package:async/async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/discovery/data/drift_known_segments_repository.dart';

import '../../../support/test_database.dart';

void main() {
  test('merkt sich entdeckte Abschnitte ohne Doppelte', () async {
    final db = testDatabase();
    addTearDown(db.close);
    final repo = DriftKnownSegmentsRepository(db);
    await repo.addAll({'a', 'b'});
    await repo.addAll({'b', 'c'});
    await repo.addAll({});
    expect(await repo.knownIds(), {'a', 'b', 'c'});
  });

  test('meldet neue Abschnitte über watchKnownIds', () async {
    final db = testDatabase();
    addTearDown(db.close);
    final repo = DriftKnownSegmentsRepository(db);
    final updates = StreamQueue(repo.watchKnownIds());
    addTearDown(updates.cancel);
    expect(await updates.next, isEmpty);
    await repo.addAll({'a'});
    expect(await updates.next, {'a'});
  });
}
