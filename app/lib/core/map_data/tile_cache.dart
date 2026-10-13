import 'dart:io';

import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/core/map_data/map_tile.dart';

/// Speichert fertige Kacheln als Dateien im App-Ordner.
class TileCache {
  TileCache(this.directory);

  final Directory directory;

  File _file(MapTile tile) => File('${directory.path}/${tile.key}.json');

  Future<List<RoadSegment>?> read(MapTile tile) async {
    final file = _file(tile);
    if (!file.existsSync()) return null;
    return RegionCodec.decode(await file.readAsString());
  }

  Future<void> write(MapTile tile, List<RoadSegment> segments) async {
    await directory.create(recursive: true);
    await _file(tile).writeAsString(RegionCodec.encode(segments));
  }
}
