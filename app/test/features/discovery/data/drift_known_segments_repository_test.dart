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
}
