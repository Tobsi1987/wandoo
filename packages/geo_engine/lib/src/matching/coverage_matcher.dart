import 'package:geo_engine/src/matching/densify.dart';
import 'package:geo_engine/src/matching/geometry.dart';
import 'package:geo_engine/src/matching/map_matcher.dart';
import 'package:geo_engine/src/matching/segment_index.dart';
import 'package:geo_engine/src/model/geo_point.dart';
import 'package:geo_engine/src/model/road_segment.dart';
import 'package:geo_engine/src/model/track.dart';

/// Matcher nach Abdeckung: Ein Abschnitt gilt als begangen, wenn die Spur
/// mindestens [minCoverage] seiner Länge abdeckt.
///
/// Vorgehen: Spur verdichten, jeden Punkt dem nächsten Abschnitt innerhalb
/// von [toleranceMeters] zuordnen und vermerken, welcher Teil des
/// Abschnitts (Fach) berührt wurde. Kreuzt man eine Straße nur, wird nur ein
/// Fach an ihrem Ende berührt, und sie zählt nicht.
class CoverageMatcher implements MapMatcher {
  const CoverageMatcher({
    this.toleranceMeters = 25,
    this.stepMeters = 5,
    this.minCoverage = 0.6,
  });

  final double toleranceMeters;
  final double stepMeters;
  final double minCoverage;

  @override
  Set<String> match(Track track, List<RoadSegment> candidates) {
    final index = SegmentIndex(candidates, paddingMeters: toleranceMeters);
    final touched = <RoadSegment, Set<int>>{};
    for (final point in densify(track.positions, stepMeters: stepMeters)) {
      final hit = _nearest(point, index.near(point));
      if (hit == null) continue;
      final bins = _binCount(hit.segment);
      final bin = (hit.t * bins).floor().clamp(0, bins - 1);
      touched.putIfAbsent(hit.segment, () => {}).add(bin);
    }
    return {
      for (final MapEntry(key: segment, value: bins) in touched.entries)
        if (bins.length / _binCount(segment) >= minCoverage) segment.id,
    };
  }

  ({RoadSegment segment, double t})? _nearest(
    GeoPoint point,
    List<RoadSegment> nearby,
  ) {
    ({RoadSegment segment, double t})? best;
    var bestDistance = toleranceMeters;
    for (final segment in nearby) {
      final p = projectOntoSegment(point, segment.start, segment.end);
      if (p.distance <= bestDistance) {
        best = (segment: segment, t: p.t);
        bestDistance = p.distance;
      }
    }
    return best;
  }

  int _binCount(RoadSegment s) =>
      (s.lengthMeters / (2 * stepMeters)).ceil().clamp(1, 20);
}
