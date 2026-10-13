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
    this.knownSegmentCount = 0,
    this.extraLines = const [],
  });

  final String walkId;
  final DateTime finishedAt;
  final int newSegmentCount;

  /// Schon bekannte Abschnitte, die wieder abgelaufen wurden. Sie machen
  /// das Wesen satt, lassen es aber nicht wachsen.
  final int knownSegmentCount;

  /// Was andere Features zum Gang zu sagen haben, z. B. Fundstücke.
  final List<String> extraLines;

  /// Dieselbe Zusammenfassung mit weiteren Zeilen.
  WalkSummary withExtraLines(List<String> lines) => WalkSummary(
    walkId: walkId,
    finishedAt: finishedAt,
    newSegmentCount: newSegmentCount,
    newStreetCount: newStreetCount,
    streetsByEnvironment: streetsByEnvironment,
    bridgeCount: bridgeCount,
    creatureGrew: creatureGrew,
    knownSegmentCount: knownSegmentCount,
    extraLines: [...extraLines, ...lines],
  );

  /// Verschiedene Straßen, auf denen mindestens ein neuer Abschnitt lag.
  final int newStreetCount;

  /// Neue Straßen je Umgebung (ohne unbekannte Umgebung).
  final Map<EnvironmentType, int> streetsByEnvironment;
  final int bridgeCount;
  final bool creatureGrew;

  bool get foundNothing => newSegmentCount == 0;
}
