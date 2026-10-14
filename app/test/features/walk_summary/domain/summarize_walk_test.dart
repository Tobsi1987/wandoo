import 'package:flutter_test/flutter_test.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/walk_summary/walk_summary.dart';

RoadSegment piece(String id, String street, {bool bridge = false}) =>
    RoadSegment(
      id: id,
      start: const GeoPoint(50, 8),
      end: const GeoPoint(50, 8.0003),
      streetId: street,
      areaTags: {if (bridge) 'bridge': 'yes'},
    );

void main() {
  final summary = const SummarizeWalk()(
    walkId: 'w',
    finishedAt: DateTime(2026, 10, 13),
    newSegments: {
      piece('a1', 'Hauptstraße'): EnvironmentType.city,
      piece('a2', 'Hauptstraße'): EnvironmentType.city,
      piece('b1', 'Waldweg'): EnvironmentType.forest,
      piece('c1', 'Mühlsteg', bridge: true): EnvironmentType.water,
      piece('d1', 'w99'): EnvironmentType.unknown,
    },
    creatureGrew: true,
  );

  test('zählt Straßen statt Stücke', () {
    expect(summary.newSegmentCount, 5);
    expect(summary.newStreetCount, 4);
    expect(summary.streetsByEnvironment, {
      EnvironmentType.city: 1,
      EnvironmentType.forest: 1,
      EnvironmentType.water: 1,
    });
    expect(summary.bridgeCount, 1);
  });
}
