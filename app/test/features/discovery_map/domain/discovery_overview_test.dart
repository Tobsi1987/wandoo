import 'package:flutter_test/flutter_test.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/discovery_map/domain/discovery_overview.dart';

RoadSegment _segment(String id, double eastDegrees) => RoadSegment(
  id: id,
  start: const GeoPoint(50, 8),
  end: GeoPoint(50, 8 + eastDegrees),
);

void main() {
  const center = GeoPoint(50, 8);

  test('gewichtet den unbekannten Anteil nach Länge', () {
    final overview = DiscoveryOverview(
      center: center,
      segments: [_segment('kurz', 0.001), _segment('lang', 0.003)],
      knownIds: {'kurz'},
    );
    expect(overview.unknownPercent, 75);
    expect(overview.known.map((s) => s.id), ['kurz']);
    expect(overview.unknown.map((s) => s.id), ['lang']);
  });

  test('alles bekannt ergibt 0 % unbekannt', () {
    final overview = DiscoveryOverview(
      center: center,
      segments: [_segment('a', 0.001)],
      knownIds: {'a'},
    );
    expect(overview.unknownPercent, 0);
  });
}
