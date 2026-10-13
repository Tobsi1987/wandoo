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

  test('entfernt Punkte, die mit Autotempo erreicht wurden', () {
    final track = Track(id: 't', points: [at(0, 0), at(0.001, 5)]);
    expect(filter.apply(track).points, hasLength(1));
  });

  test('entfernt ungenaue Punkte', () {
    final track = Track(id: 't', points: [at(0, 0, accuracy: 80)]);
    expect(filter.apply(track).points, isEmpty);
  });
}
