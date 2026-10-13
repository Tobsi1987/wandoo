import 'package:geo_engine/src/matching/geometry.dart';
import 'package:geo_engine/src/model/geo_point.dart';
import 'package:geo_engine/src/model/road_segment.dart';
import 'package:geo_engine/src/osm/osm_data.dart';
import 'package:geo_engine/src/osm/polygon.dart';

/// Hängt jedem Abschnitt die Tags seiner Umgebung an.
///
/// Gewählt wird die kleinste Fläche, in der die Mitte des Abschnitts
/// liegt (ein Park im Wohngebiet schlägt das Wohngebiet). Liegt ein
/// Gewässer näher als [waterMeters], kommt dessen Tag dazu.
class AreaTagger {
  const AreaTagger({this.waterMeters = 40});

  final double waterMeters;

  List<RoadSegment> tag(List<RoadSegment> segments, OsmData osm) {
    final areas = [
      for (final a in osm.areas)
        (area: a, bounds: Bounds.of(a.outer.expand((r) => r))),
    ];
    final pad = metersToLatDegrees(waterMeters) * 2;
    final waters = [
      for (final w in osm.waterLines)
        (line: w, bounds: Bounds.of(w.points, padDegrees: pad)),
    ];
    return [
      for (final s in segments)
        _withTags(s, interpolate(s.start, s.end, 0.5), areas, waters),
    ];
  }

  RoadSegment _withTags(
    RoadSegment s,
    GeoPoint mid,
    List<({OsmArea area, Bounds bounds})> areas,
    List<({OsmWaterLine line, Bounds bounds})> waters,
  ) {
    final tags = <String, String>{...?_smallestArea(mid, areas)?.tags};
    for (final w in waters) {
      if (w.bounds.contains(mid) && _near(mid, w.line.points)) {
        tags['waterway'] = w.line.tags['waterway'] ?? 'river';
        break;
      }
    }
    return RoadSegment(
      id: s.id,
      start: s.start,
      end: s.end,
      streetId: s.streetId,
      areaTags: tags,
    );
  }

  OsmArea? _smallestArea(
    GeoPoint p,
    List<({OsmArea area, Bounds bounds})> areas,
  ) {
    OsmArea? best;
    var bestSize = double.infinity;
    for (final (:area, :bounds) in areas) {
      if (!bounds.contains(p)) continue;
      final outer = area.outer.where((r) => ringContains(r, p));
      if (outer.isEmpty || area.inner.any((r) => ringContains(r, p))) {
        continue;
      }
      final size = ringArea(outer.first);
      if (size < bestSize) {
        best = area;
        bestSize = size;
      }
    }
    return best;
  }

  bool _near(GeoPoint p, List<GeoPoint> line) {
    for (var i = 1; i < line.length; i++) {
      if (projectOntoSegment(p, line[i - 1], line[i]).distance <= waterMeters) {
        return true;
      }
    }
    return false;
  }
}
