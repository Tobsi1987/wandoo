import 'package:geo_engine/geo_engine.dart';
import 'package:test/test.dart';

TrackPoint at(double eastDeg, int seconds, {double? accuracy}) => TrackPoint(
  GeoPoint(50, 8 + eastDeg),
  DateTime.utc(2026).add(Duration(seconds: seconds)),
  accuracyMeters: accuracy,
);

void main() {
  const filter = WalkingFilter();

  test('behält Gehgeschwindigkeit', () {
    // 0.0001° Länge bei 50° Breite sind rund 7 m, in 5 s also ~5 km/h.
    final track = Track(id: 't', points: [at(0, 0), at(0.0001, 5)]);
    expect(filter.apply(track).points, hasLength(2));
  });

  test('entfernt GPS-Sprünge', () {
    final track = Track(id: 't', points: [at(0, 0), at(0.001, 5)]);
    expect(filter.apply(track).points, hasLength(1));
  });

  // 0.0001° sind rund 7,17 m. Ein Punkt alle 5 s.
  Track steady(double kmh, {int points = 13}) {
    final degPerStep = kmh / 3.6 * 5 / 71700;
    return Track(
      id: 't',
      points: [for (var i = 0; i < points; i++) at(i * degPerStep, i * 5)],
    );
  }

  test('Joggen mit 12 km/h zählt', () {
    expect(filter.apply(steady(12)).points, hasLength(13));
  });

  test('Stadtverkehr mit 25 km/h zählt nicht', () {
    // Nur die ersten Punkte bleiben, bis das Fenster 5 s Daten hat.
    expect(filter.apply(steady(25)).points.length, lessThan(2));
  });

  test('wer aus dem Auto steigt, zählt wieder, sobald er geht', () {
    final car = steady(30, points: 7).points;
    final carEnd = car.last;
    final walk = [
      for (var i = 1; i <= 12; i++)
        TrackPoint(
          GeoPoint(50, carEnd.position.longitude + i * 7 / 71700),
          carEnd.time.add(Duration(seconds: 5 * i)),
        ),
    ];
    final kept = filter.apply(Track(id: 't', points: [...car, ...walk]));
    expect(kept.points.length, inInclusiveRange(6, 12));
    expect(kept.points.last, walk.last);
  });

  test('entfernt ungenaue Punkte', () {
    final track = Track(id: 't', points: [at(0, 0, accuracy: 80)]);
    expect(filter.apply(track).points, isEmpty);
  });
}
