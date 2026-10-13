import 'dart:convert';

import 'package:geo_engine/src/model/geo_point.dart';
import 'package:geo_engine/src/osm/osm_data.dart';

/// Liest eine Overpass-Antwort im JSON-Format mit `out geom`.
abstract final class OverpassParser {
  static OsmData parse(String json) {
    final elements =
        (jsonDecode(json) as Map<String, dynamic>)['elements'] as List;
    final roads = <OsmRoad>[];
    final areas = <OsmArea>[];
    final waterLines = <OsmWaterLine>[];
    for (final raw in elements.cast<Map<String, dynamic>>()) {
      final tags = _tags(raw['tags']);
      if (raw['type'] == 'relation') {
        final area = _relationArea(raw, tags);
        if (area != null) areas.add(area);
        continue;
      }
      if (raw['type'] != 'way') continue;
      final points = _geometry(raw['geometry']);
      if (points.length < 2) continue;
      if (tags.containsKey('highway')) {
        roads.add(
          OsmRoad(
            id: raw['id'] as int,
            nodeIds: (raw['nodes'] as List).cast<int>(),
            points: points,
            tags: tags,
          ),
        );
      } else if (tags.containsKey('waterway')) {
        waterLines.add(OsmWaterLine(points: points, tags: tags));
      } else if (_isClosed(points)) {
        areas.add(OsmArea(outer: [points], inner: const [], tags: tags));
      }
    }
    return OsmData(roads: roads, areas: areas, waterLines: waterLines);
  }

  static OsmArea? _relationArea(
    Map<String, dynamic> raw,
    Map<String, String> tags,
  ) {
    final outer = <List<GeoPoint>>[];
    final inner = <List<GeoPoint>>[];
    for (final m in (raw['members'] as List? ?? const [])) {
      final member = m as Map<String, dynamic>;
      if (member['type'] != 'way') continue;
      final ring = _geometry(member['geometry']);
      if (!_isClosed(ring)) continue; // Zusammengesetzte Ringe: später.
      (member['role'] == 'inner' ? inner : outer).add(ring);
    }
    if (outer.isEmpty) return null;
    return OsmArea(outer: outer, inner: inner, tags: tags);
  }

  static Map<String, String> _tags(Object? raw) =>
      raw == null ? const {} : (raw as Map).cast<String, String>();

  static List<GeoPoint> _geometry(Object? raw) => [
    for (final p in (raw as List? ?? const []).cast<Map<String, dynamic>>())
      GeoPoint((p['lat'] as num).toDouble(), (p['lon'] as num).toDouble()),
  ];

  static bool _isClosed(List<GeoPoint> ring) =>
      ring.length >= 4 && ring.first == ring.last;
}
