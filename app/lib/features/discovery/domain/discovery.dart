import 'package:geo_engine/geo_engine.dart';

/// Was ein Gang auf der Karte ergeben hat.
class Discovery {
  const Discovery({required this.fresh, required this.knownCount});

  /// Abschnitte, die heute zum ersten Mal begangen wurden.
  final List<RoadSegment> fresh;

  /// Wie viele schon bekannte Abschnitte der Gang wieder abgelaufen ist.
  final int knownCount;
}
