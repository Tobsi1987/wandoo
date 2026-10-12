import 'package:geo_engine/src/model/road_segment.dart';

/// Anteil der Straßenlänge eines Gebiets, die schon entdeckt ist.
///
/// Grundlage für "noch 23 % unbekannt" auf der Entdeckungskarte.
class DiscoveryQuota {
  const DiscoveryQuota();

  /// Wert zwischen 0 und 1, nach Länge gewichtet.
  double compute(Iterable<RoadSegment> area, Set<String> knownIds) {
    var total = 0.0;
    var known = 0.0;
    for (final segment in area) {
      final length = segment.lengthMeters;
      total += length;
      if (knownIds.contains(segment.id)) known += length;
    }
    return total == 0 ? 0 : known / total;
  }
}
