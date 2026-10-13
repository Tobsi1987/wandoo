import 'package:geo_engine/geo_engine.dart';

/// Was ein Gang gebracht hat, so wie es nach dem Gang gezeigt wird.
class WalkSummary {
  const WalkSummary({
    required this.walkId,
    required this.finishedAt,
    required this.newSegmentCount,
    required this.newStreetCount,
    required this.streetsByEnvironment,
    required this.bridgeCount,
    required this.creatureGrew,
  });

  final String walkId;
  final DateTime finishedAt;
  final int newSegmentCount;

  /// Verschiedene Straßen, auf denen mindestens ein neuer Abschnitt lag.
  final int newStreetCount;

  /// Neue Straßen je Umgebung (ohne unbekannte Umgebung).
  final Map<EnvironmentType, int> streetsByEnvironment;
  final int bridgeCount;
  final bool creatureGrew;

  bool get foundNothing => newSegmentCount == 0;
}
