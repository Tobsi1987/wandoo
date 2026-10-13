import 'package:flutter_test/flutter_test.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/walk_summary/domain/summary_lines.dart';
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

  test('formuliert die Zeilen wie im Konzept', () {
    expect(summaryLines(summary), [
      '+4 neue Straßen',
      '1 Waldstück',
      '1 Weg am Wasser',
      '1 Stadtstraße',
      '1 Brücke',
      'Dein Wesen ist gewachsen!',
    ]);
  });

  test('ohne Neues gibt es einen freundlichen Hinweis', () {
    final empty = const SummarizeWalk()(
      walkId: 'w',
      finishedAt: DateTime(2026),
      newSegments: const {},
      creatureGrew: false,
    );
    expect(summaryLines(empty).single, startsWith('Wachsen tut es nur'));
  });

  test('bekannte Wege machen satt, aber nicht größer', () {
    final known = const SummarizeWalk()(
      walkId: 'w',
      finishedAt: DateTime(2026),
      newSegments: const {},
      creatureGrew: false,
      knownSegmentCount: 4,
    );
    expect(summaryLines(known), [
      'Bekannte Wege: Dein Wesen ist satt.',
      startsWith('Wachsen tut es nur'),
    ]);
  });
}
