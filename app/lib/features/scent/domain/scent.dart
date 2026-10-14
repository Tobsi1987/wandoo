import 'package:geo_engine/geo_engine.dart';

/// Was das Wesen gerade riecht: ein Fund auf einer unbekannten Straße.
class Scent {
  const Scent({
    required this.target,
    required this.createdAt,
    this.environment,
  });

  /// Mitte des unbekannten Abschnitts, auf dem der Fund liegt.
  final GeoPoint target;

  /// Umgebung des Abschnitts; daraus ergibt sich das Fundstück.
  final EnvironmentType? environment;
  final DateTime createdAt;

  /// So nah muss man kommen, damit der Fund zählt.
  static const reachMeters = 30.0;

  /// Ob [track] an der Stelle vorbeigekommen ist.
  bool reachedBy(Track track) =>
      track.positions.any((p) => p.distanceTo(target) <= reachMeters);
}
