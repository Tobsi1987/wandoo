import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/core/map_data/map_tile.dart';
import 'package:wandoo/core/map_data/tile_cache.dart';
import 'package:wandoo/core/map_data/tiled_map_data_source.dart';

/// Eine Overpass-Antwort mit einem 70 m langen Weg in Kachel t1000_160.
final String _overpass = jsonEncode({
  'elements': [
    {
      'type': 'way',
      'id': 7,
      'nodes': [1, 2],
      'geometry': [
        {'lat': 50.01, 'lon': 8.01},
        {'lat': 50.01, 'lon': 8.011},
      ],
      'tags': {'highway': 'footway'},
    },
  ],
});

void main() {
  late Directory dir;
  setUp(() => dir = Directory.systemTemp.createTempSync('tiles'));
  tearDown(() => dir.deleteSync(recursive: true));

  test('lädt eine Kachel einmal und liest sie danach aus der Datei', () async {
    var calls = 0;
    Future<String> fetch(String query) async {
      calls++;
      return _overpass;
    }

    final first = TiledMapDataSource(cache: TileCache(dir), fetch: fetch);
    final segments = await first.segmentsIn(const MapTile(1000, 160));
    expect(segments.map((s) => s.id), contains('w7-0'));
    await first.segmentsIn(const MapTile(1000, 160));
    expect(calls, 1);

    final afterRestart = TiledMapDataSource(
      cache: TileCache(dir),
      fetch: fetch,
    );
    await afterRestart.segmentsIn(const MapTile(1000, 160));
    expect(calls, 1);
  });

  test('Abschnitte außerhalb der Kachel gehören der Nachbarkachel', () async {
    final source = TiledMapDataSource(
      cache: TileCache(dir),
      fetch: (_) async => _overpass,
    );
    expect(await source.segmentsIn(const MapTile(1000, 161)), isEmpty);
  });

  test('nach einem Fehler wird neu geladen', () async {
    var fail = true;
    final source = TiledMapDataSource(
      cache: TileCache(dir),
      fetch: (_) async =>
          fail ? throw const SocketException('offline') : _overpass,
    );
    final points = [const GeoPoint(50.01, 8.0105)];
    await expectLater(
      source.segmentsNear(points),
      throwsA(isA<SocketException>()),
    );
    fail = false;
    expect(await source.segmentsNear(points), isNotEmpty);
  });
}
