import 'dart:isolate';

import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/core/map_data/map_data_source.dart';
import 'package:wandoo/core/map_data/map_tile.dart';
import 'package:wandoo/core/map_data/tile_cache.dart';

/// Lädt Abschnitte kachelweise: erst aus dem Speicher, dann aus der Datei,
/// sonst über [fetch] (Overpass) und speichert das Ergebnis dauerhaft.
class TiledMapDataSource implements MapDataSource {
  TiledMapDataSource({required this.cache, required this.fetch});

  final TileCache cache;

  /// Führt eine Overpass-Abfrage aus und liefert die JSON-Antwort.
  final Future<String> Function(String query) fetch;

  final Map<MapTile, Future<List<RoadSegment>>> _loaded = {};

  @override
  Future<List<RoadSegment>> segmentsNear(List<GeoPoint> points) async {
    // Etwas Rand, damit Abschnitte aus der Nachbarkachel dabei sind.
    final tiles = MapTile.covering(points, padDegrees: 0.002);
    final parts = await Future.wait(tiles.map(segmentsIn));
    return [for (final part in parts) ...part];
  }

  /// Alle Abschnitte einer Kachel. Gleichzeitige Anfragen teilen sich einen
  /// Ladevorgang; schlägt er fehl, wird beim nächsten Mal neu versucht.
  Future<List<RoadSegment>> segmentsIn(MapTile tile) {
    final pending = _loaded[tile];
    if (pending != null) return pending;
    final loading = _load(tile);
    _loaded[tile] = loading;
    loading
        .then<void>(
          (_) {},
          onError: (Object _) {
            _loaded.remove(tile)?.ignore();
          },
        )
        .ignore();
    return loading;
  }

  Future<List<RoadSegment>> _load(MapTile tile) async =>
      await cache.read(tile) ?? await _download(tile);

  Future<List<RoadSegment>> _download(MapTile tile) async {
    final json = await fetch(
      overpassQuery(tile.south, tile.west, tile.north, tile.east),
    );
    // Aufbereiten im Hintergrund, damit die Oberfläche flüssig bleibt.
    final all = await Isolate.run(
      () => const RegionBuilder().fromOverpassJson(json),
    );
    // Overpass liefert ganze Wege; jeder Abschnitt gehört nur einer Kachel.
    final own = [
      for (final s in all)
        if (tile.contains(s.start)) s,
    ];
    await cache.write(tile, own);
    return own;
  }
}
