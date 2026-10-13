import 'package:geo_engine/geo_engine.dart';
import 'package:geo_engine/src/osm/osm_data.dart';
import 'package:geo_engine/src/osm/road_splitter.dart';
import 'package:test/test.dart';

void main() {
  test('dichte Knoten werden zu Stücken von rund 25 m zusammengefasst', () {
    // Elf Knoten im Abstand von etwa 7 m in Ost-West-Richtung.
    final road = OsmRoad(
      id: 5,
      nodeIds: [for (var i = 0; i <= 10; i++) i],
      points: [for (var i = 0; i <= 10; i++) GeoPoint(50, 8 + 0.0001 * i)],
      tags: const {},
    );
    final pieces = const RoadSplitter().split([road]);
    expect(pieces.length, 3);
    expect(pieces.first.lengthMeters, greaterThanOrEqualTo(25));
    expect(pieces.last.end, road.points.last);
  });
}
