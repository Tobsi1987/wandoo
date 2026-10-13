import 'package:geo_engine/src/model/road_segment.dart';
import 'package:geo_engine/src/osm/osm_data.dart';

/// Zerlegt OSM-Wege in kurze, gerade Abschnitte.
///
/// Geteilt wird an jeder Kreuzung und sonst, sobald ein Stück
/// [targetMeters] erreicht. Kurze Stücke folgen Kurven gut genug, und
/// eine Kreuzung trennt immer zwei Abschnitte.
class RoadSplitter {
  const RoadSplitter({this.targetMeters = 25});

  final double targetMeters;

  List<RoadSegment> split(List<OsmRoad> roads) {
    final usage = <int, int>{};
    for (final road in roads) {
      for (final node in road.nodeIds) {
        usage.update(node, (n) => n + 1, ifAbsent: () => 1);
      }
    }
    return [for (final road in roads) ..._splitRoad(road, usage)];
  }

  Iterable<RoadSegment> _splitRoad(OsmRoad road, Map<int, int> usage) sync* {
    final streetId = road.tags['name'] ?? 'w${road.id}';
    final ownTags = {if (road.tags['bridge'] == 'yes') 'bridge': 'yes'};
    final last = road.points.length - 1;
    var start = 0;
    var length = 0.0;
    var piece = 0;
    for (var i = 1; i <= last; i++) {
      length += road.points[i - 1].distanceTo(road.points[i]);
      final atCrossing =
          i < road.nodeIds.length && (usage[road.nodeIds[i]] ?? 0) > 1;
      if (i == last || atCrossing || length >= targetMeters) {
        yield RoadSegment(
          id: 'w${road.id}-${piece++}',
          start: road.points[start],
          end: road.points[i],
          streetId: streetId,
          areaTags: ownTags,
        );
        start = i;
        length = 0;
      }
    }
  }
}
