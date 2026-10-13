import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/bootstrap/demo/demo_route.dart';
import 'package:wandoo/bootstrap/demo/demo_town.dart';

void main() {
  test('Rundgang bleibt in der Stadt und kehrt nie direkt um', () {
    final route = randomRoute(math.Random(7), blocks: 40);
    expect(route, hasLength(41));
    for (var i = 2; i < route.length; i++) {
      expect(route[i], isNot(route[i - 2]));
    }
    final last = DemoTown.node(DemoTown.size - 1, DemoTown.size - 1);
    for (final p in route) {
      expect(
        p.latitude,
        inInclusiveRange(DemoTown.origin.latitude, last.latitude),
      );
      expect(
        p.longitude,
        inInclusiveRange(DemoTown.origin.longitude, last.longitude),
      );
    }
  });

  test('simulierte Spur gilt als Gehen und deckt neue Abschnitte auf', () {
    final random = math.Random(3);
    final points = sampleRoute(
      randomRoute(random),
      random,
      start: DateTime.utc(2026, 10, 13, 8),
    );
    final track = Track(id: 'demo', points: points);
    final walked = const WalkingFilter().apply(track);
    expect(walked.points.length, points.length);
    final covered = const CoverageMatcher().match(walked, DemoTown.segments);
    expect(covered.length, greaterThanOrEqualTo(10));
  });
}
