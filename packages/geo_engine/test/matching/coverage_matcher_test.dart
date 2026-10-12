import 'package:geo_engine/geo_engine.dart';
import 'package:test/test.dart';

import '../support/fixtures.dart';

void main() {
  final town = Fixtures.town();
  const matcher = CoverageMatcher();
  const filter = WalkingFilter();

  Set<String> walked(String name) =>
      matcher.match(filter.apply(Fixtures.gpx(name)), town);

  test('Gang über die Hauptstraße trifft genau ihre vier Abschnitte', () {
    expect(walked('main_street'), {'h2-0', 'h2-1', 'h2-2', 'h2-3'});
  });

  test('gekreuzte Querstraßen zählen nicht', () {
    expect(walked('main_street').where((id) => id.startsWith('v')), isEmpty);
  });

  test('seltene Messpunkte mit Abbiegen werden überbrückt', () {
    expect(walked('sparse_turn'), {'h0-0', 'h0-1', 'v2-0', 'v2-1'});
  });

  test('Autofahrt bringt nichts', () {
    expect(walked('drive_through'), isEmpty);
  });

  test('Runde im Wald mit starkem Rauschen', () {
    expect(walked('forest_loop'), {
      'h1-3',
      'v4-1',
      'v4-2',
      'h3-3',
      'v3-1',
      'v3-2',
    });
  });

  test('zu 40 Prozent begangener Abschnitt zählt nicht', () {
    final half = Track(
      id: 'half',
      points: [
        TrackPoint(town.first.start, DateTime.utc(2026)),
        TrackPoint(
          GeoPoint(
            town.first.start.latitude +
                (town.first.end.latitude - town.first.start.latitude) * 0.4,
            town.first.start.longitude +
                (town.first.end.longitude - town.first.start.longitude) * 0.4,
          ),
          DateTime.utc(2026, 1, 1, 0, 1),
        ),
      ],
    );
    expect(matcher.match(half, town), isNot(contains(town.first.id)));
  });
}
