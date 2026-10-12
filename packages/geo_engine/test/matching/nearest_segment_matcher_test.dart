import 'package:geo_engine/geo_engine.dart';
import 'package:test/test.dart';

void main() {
  // Zwei parallele Straßen in Ost-West-Richtung, rund 110 m auseinander.
  const north = RoadSegment(
    id: 'north',
    start: GeoPoint(50.001, 8),
    end: GeoPoint(50.001, 8.002),
  );
  const south = RoadSegment(
    id: 'south',
    start: GeoPoint(50, 8),
    end: GeoPoint(50, 8.002),
  );

  Track walk(List<GeoPoint> points) =>
      Track(id: 't', points: points, startedAt: DateTime(2026));

  test('ordnet Punkte nahe einer Straße dieser Straße zu', () {
    final track = walk(const [
      GeoPoint(50.00005, 8.0005),
      GeoPoint(50.00003, 8.001),
      GeoPoint(50.00004, 8.0015),
    ]);
    final matched = const NearestSegmentMatcher().match(track, [north, south]);
    expect(matched, {'south'});
  });

  test('ignoriert Punkte außerhalb der Toleranz', () {
    final track = walk(const [
      GeoPoint(50.0005, 8.001),
      GeoPoint(50.0005, 8.0012),
    ]);
    expect(const NearestSegmentMatcher().match(track, [north, south]), isEmpty);
  });

  test('ein einzelner Ausreißer reicht nicht', () {
    final track = walk(const [GeoPoint(50.00001, 8.001)]);
    expect(const NearestSegmentMatcher().match(track, [south]), isEmpty);
  });

  test('Abstand zum Abschnitt in Metern', () {
    const p = GeoPoint(50.0001, 8.001);
    expect(
      NearestSegmentMatcher.distanceToSegment(p, south),
      closeTo(11.1, 0.2),
    );
  });
}
