import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/tracking/domain/walk_recorder.dart';

import '../../../support/fake_location_source.dart';

void main() {
  test('zählt Strecke und verwirft Zittern im Stehen', () {
    final recorder = WalkRecorder(id: 'w')
      ..add(eastOf(0, 0))
      ..add(eastOf(1, 5))
      ..add(eastOf(10, 10))
      ..add(eastOf(20, 15));
    expect(recorder.finish().points, hasLength(3));
    expect(recorder.distanceMeters, closeTo(20, 0.5));
  });

  test('ein einzelner Punkt ist noch kein Gang', () {
    final recorder = WalkRecorder(id: 'w')..add(eastOf(0, 0));
    expect(recorder.hasWalk, isFalse);
  });

  test('merkt, wenn es zu schnell für zu Fuß wird', () {
    final recorder = WalkRecorder(id: 'g');
    for (var i = 0; i < 8; i++) {
      recorder.add(eastOf(i * 50.0, i * 5));
    }
    expect(recorder.tooFast, isTrue);
  });
}
