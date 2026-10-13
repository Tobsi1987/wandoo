import 'package:flutter_test/flutter_test.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/core/map_data/map_tile.dart';

void main() {
  test('ein Punkt liegt in genau einer Kachel', () {
    final tile = MapTile.containing(const GeoPoint(50.012, 8.034));
    expect(tile, const MapTile(1000, 160));
    expect(tile.south, closeTo(50, 1e-9));
    expect(tile.east, closeTo(8.05, 1e-9));
    expect(tile.key, 't1000_160');
  });

  test('Spur über eine Kachelgrenze braucht beide Kacheln', () {
    final tiles = MapTile.covering(const [
      GeoPoint(50.01, 8.049),
      GeoPoint(50.01, 8.051),
    ]);
    expect(tiles, {const MapTile(1000, 160), const MapTile(1000, 161)});
  });

  test('Rand nimmt die Nachbarkachel dazu', () {
    final tiles = MapTile.covering(const [
      GeoPoint(50.01, 8.0495),
    ], padDegrees: 0.002);
    expect(tiles, contains(const MapTile(1000, 161)));
  });
}
