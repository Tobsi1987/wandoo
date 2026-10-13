import 'package:flutter_test/flutter_test.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/discovery/data/in_memory_known_segments_repository.dart';
import 'package:wandoo/features/districts/districts.dart';
import 'package:wandoo/features/walk_summary/walk_summary.dart';
import 'package:wandoo/flows/process_walk/extras/district_extra.dart';
import 'package:wandoo/flows/process_walk/walk_extra.dart';

void main() {
  test('meldet das Abzeichen, sobald 80 % erreicht sind', () async {
    final street = [
      for (var i = 0; i < 10; i++)
        RoadSegment(
          id: 's$i',
          start: GeoPoint(50.005, 8 + i * 0.001),
          end: GeoPoint(50.005, 8 + (i + 1) * 0.001),
        ),
    ];
    final known = InMemoryKnownSegmentsRepository();
    await known.addAll({for (var i = 0; i < 8; i++) 's$i'});
    final lines = await DistrictExtra(known).onWalk(
      WalkOutcome(
        track: const Track(id: 'gang', points: []),
        summary: WalkSummary(
          walkId: 'gang',
          finishedAt: DateTime(2026, 10, 14),
          newSegmentCount: 1,
          newStreetCount: 1,
          streetsByEnvironment: const {},
          bridgeCount: 0,
          creatureGrew: false,
        ),
        newSegmentsByEnvironment: const {EnvironmentType.city: 1},
        nearby: street,
        freshIds: const {'s7'},
      ),
    );
    expect(lines, [badgeLine(const District(5000, 800))]);
  });
}
