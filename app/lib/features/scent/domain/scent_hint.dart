import 'dart:math' as math;

import 'package:geo_engine/geo_engine.dart';

/// Wie nah die Spürnase dran ist, wie beim Heiß-und-kalt-Spiel.
enum Heat { found, hot, warm, cool, cold }

/// Hinweis für unterwegs: wie warm, und in welche Richtung es geht.
class ScentHint {
  const ScentHint({required this.heat, required this.meters, this.turn});

  /// Hinweis von [here] zu [target]. [cameFrom] ist ein Punkt kurz davor
  /// auf dem Weg; ohne ihn ist die Gehrichtung unbekannt.
  factory ScentHint.toward(
    GeoPoint target,
    GeoPoint here, {
    GeoPoint? cameFrom,
    double reach = 30,
  }) {
    final meters = here.distanceTo(target);
    final heat = switch (meters) {
      _ when meters <= reach => Heat.found,
      < 80 => Heat.hot,
      < 200 => Heat.warm,
      < 400 => Heat.cool,
      _ => Heat.cold,
    };
    double? turn;
    if (cameFrom != null && heat != Heat.found) {
      final going = bearing(cameFrom, here);
      turn = _wrap(bearing(here, target) - going);
    }
    return ScentHint(heat: heat, meters: meters, turn: turn);
  }

  final Heat heat;
  final double meters;

  /// Wie weit sich die Richtung zum Fund von der Gehrichtung unterscheidet,
  /// im Bogenmaß, positiv nach rechts. `null`, wenn die Gehrichtung
  /// unbekannt ist oder der Fund erreicht.
  final double? turn;

  /// Kompassrichtung von [a] nach [b] im Bogenmaß, 0 = Norden, im
  /// Uhrzeigersinn.
  static double bearing(GeoPoint a, GeoPoint b) {
    final lat1 = a.latitude * math.pi / 180;
    final lat2 = b.latitude * math.pi / 180;
    final dLon = (b.longitude - a.longitude) * math.pi / 180;
    final y = math.sin(dLon) * math.cos(lat2);
    final x =
        math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);
    return math.atan2(y, x);
  }

  static double _wrap(double a) {
    var r = a % (2 * math.pi);
    if (r > math.pi) r -= 2 * math.pi;
    return r;
  }
}
