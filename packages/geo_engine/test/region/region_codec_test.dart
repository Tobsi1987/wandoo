import 'package:geo_engine/geo_engine.dart';
import 'package:test/test.dart';

void main() {
  test('kodieren und dekodieren erhält alle Felder', () {
    const segment = RoadSegment(
      id: 'w1-0',
      start: GeoPoint(50, 8),
      end: GeoPoint(50.001, 8.001),
      areaTags: {'landuse': 'forest'},
    );
    final back = RegionCodec.decode(RegionCodec.encode([segment])).single;
    expect(back.id, segment.id);
    expect(back.start, segment.start);
    expect(back.end, segment.end);
    expect(back.areaTags, segment.areaTags);
  });

  test('falsche Version ist ein Fehler', () {
    expect(
      () => RegionCodec.decode('{"v":99,"segments":[]}'),
      throwsFormatException,
    );
  });
}
