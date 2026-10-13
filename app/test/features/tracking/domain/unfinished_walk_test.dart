import 'package:flutter_test/flutter_test.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/tracking/domain/unfinished_walk.dart';

import '../../../support/fake_location_source.dart';

void main() {
  const policy = UnfinishedWalkPolicy();
  final track = Track(id: 'g', points: [eastOf(0, 0), eastOf(20, 15)]);
  final lastPoint = track.points.last.time;

  test('kurz her: weiter', () {
    final now = lastPoint.add(const Duration(minutes: 10));
    expect(policy.decide(track, now), UnfinishedWalkAction.resume);
  });

  test('lange her: abschließen', () {
    final now = lastPoint.add(const Duration(hours: 1));
    expect(policy.decide(track, now), UnfinishedWalkAction.finish);
  });

  test('ein Punkt ist kein Gang', () {
    final single = Track(id: 'g', points: [eastOf(0, 0)]);
    expect(policy.decide(single, lastPoint), UnfinishedWalkAction.discard);
  });
}
