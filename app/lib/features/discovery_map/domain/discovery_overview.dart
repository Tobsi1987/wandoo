import 'package:geo_engine/geo_engine.dart';

/// Was die Entdeckungskarte zeigt: alle Abschnitte der Gegend, welche
/// davon bekannt sind, und wie viel noch unbekannt ist.
class DiscoveryOverview {
  DiscoveryOverview({
    required this.center,
    required this.segments,
    required this.knownIds,
  }) : knownShare = const DiscoveryQuota().compute(segments, knownIds);

  final GeoPoint center;
  final List<RoadSegment> segments;
  final Set<String> knownIds;

  /// Anteil der bekannten Straßenlänge (0 bis 1).
  final double knownShare;

  /// Ganze Prozent, die noch unbekannt sind, für "noch 23 % unbekannt".
  int get unknownPercent => ((1 - knownShare) * 100).round();

  Iterable<RoadSegment> get known =>
      segments.where((s) => knownIds.contains(s.id));

  Iterable<RoadSegment> get unknown =>
      segments.where((s) => !knownIds.contains(s.id));
}
