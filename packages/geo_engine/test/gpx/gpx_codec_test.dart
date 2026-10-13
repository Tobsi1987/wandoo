import 'package:geo_engine/geo_engine.dart';
import 'package:test/test.dart';

void main() {
  test('schreiben und lesen ergibt dieselbe Spur', () {
    final track = Track(
      id: 'rund',
      points: [
        TrackPoint(const GeoPoint(50.1, 8.2), DateTime.utc(2026, 10, 12, 8)),
        TrackPoint(const GeoPoint(50.2, 8.3), DateTime.utc(2026, 10, 12, 9)),
      ],
    );
    final back = GpxCodec.decode(GpxCodec.encode(track), id: 'rund');
    expect(back.positions, track.positions);
    expect(back.startedAt, track.startedAt);
  });

  test('akzeptiert lon vor lat und einfache Anführungszeichen', () {
    const gpx =
        "<trkpt lon='8.5' lat='50.5'><time>2026-10-12T08:00:00Z</time></trkpt>";
    expect(GpxCodec.decode(gpx, id: 'x').positions, [
      const GeoPoint(50.5, 8.5),
    ]);
  });

  test('Trackpunkt ohne Zeit ist ein Fehler', () {
    const gpx = '<trkpt lat="50" lon="8"><ele>100</ele></trkpt>';
    expect(() => GpxCodec.decode(gpx, id: 'x'), throwsFormatException);
  });
}
