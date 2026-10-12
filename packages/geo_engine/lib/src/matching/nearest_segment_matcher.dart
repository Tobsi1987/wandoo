import 'dart:math' as math;

import 'package:geo_engine/src/matching/map_matcher.dart';
import 'package:geo_engine/src/model/geo_point.dart';
import 'package:geo_engine/src/model/road_segment.dart';
import 'package:geo_engine/src/model/track.dart';

/// Einfacher Matcher: Jeder GPS-Punkt zählt für den nächstgelegenen
/// Abschnitt innerhalb von [toleranceMeters]. Ein Abschnitt gilt als
/// begangen, sobald [minHits] Punkte auf ihn fallen.
///
/// Bewusst simpel als Startpunkt. Für Kreuzungen und ungenaues GPS braucht
/// es später ein Verfahren, das die Reihenfolge der Punkte berücksichtigt.
class NearestSegmentMatcher implements MapMatcher {
  const NearestSegmentMatcher({this.toleranceMeters = 20, this.minHits = 2});

  final double toleranceMeters;
  final int minHits;

  @override
  Set<String> match(Track track, List<RoadSegment> candidates) {
    final hits = <String, int>{};
    for (final point in track.points) {
      final nearest = _nearest(point, candidates);
      if (nearest != null) {
        hits.update(nearest.id, (n) => n + 1, ifAbsent: () => 1);
      }
    }
    return {
      for (final entry in hits.entries)
        if (entry.value >= minHits) entry.key,
    };
  }

  RoadSegment? _nearest(GeoPoint point, List<RoadSegment> candidates) {
    RoadSegment? best;
    var bestDistance = toleranceMeters;
    for (final segment in candidates) {
      final d = distanceToSegment(point, segment);
      if (d <= bestDistance) {
        best = segment;
        bestDistance = d;
      }
    }
    return best;
  }

  /// Abstand Punkt zu Strecke in Metern. Lokale ebene Näherung, für
  /// Abschnitte von wenigen hundert Metern genau genug.
  static double distanceToSegment(GeoPoint p, RoadSegment s) {
    const metersPerDegLat = GeoPoint.earthRadiusMeters * math.pi / 180;
    final metersPerDegLon =
        metersPerDegLat * math.cos(p.latitude * math.pi / 180);
    // Ebene Koordinaten in Metern, mit p im Ursprung.
    final a = (
      (s.start.longitude - p.longitude) * metersPerDegLon,
      (s.start.latitude - p.latitude) * metersPerDegLat,
    );
    final b = (
      (s.end.longitude - p.longitude) * metersPerDegLon,
      (s.end.latitude - p.latitude) * metersPerDegLat,
    );
    final dx = b.$1 - a.$1;
    final dy = b.$2 - a.$2;
    final lengthSquared = dx * dx + dy * dy;
    final t = lengthSquared == 0
        ? 0.0
        : ((-a.$1 * dx - a.$2 * dy) / lengthSquared).clamp(0.0, 1.0);
    final cx = a.$1 + t * dx;
    final cy = a.$2 + t * dy;
    return math.sqrt(cx * cx + cy * cy);
  }
}
