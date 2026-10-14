import 'dart:math';

import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/scent/domain/scent.dart';

/// Ein Straßenabschnitt, auf dem ein Fund liegen könnte.
typedef ScentSpot = ({GeoPoint at, EnvironmentType? environment});

/// Sucht eine unbekannte Straße in Gehweite aus, auf der etwas liegt.
///
/// Am liebsten nicht zu nah (sonst ist es keine Suche) und nicht zu weit
/// (Kinder sollen hinkommen). Gibt es dort nichts, gilt ein weiterer Kreis.
class PickScent {
  const PickScent({
    this.near = 120,
    this.far = 500,
    this.widerNear = 50,
    this.widerFar = 900,
  });

  final double near;
  final double far;
  final double widerNear;
  final double widerFar;

  Scent? call(
    GeoPoint here,
    List<ScentSpot> unknown,
    DateTime now,
    Random random,
  ) {
    List<ScentSpot> within(double a, double b) => [
      for (final s in unknown)
        if (_between(here.distanceTo(s.at), a, b)) s,
    ];
    var spots = within(near, far);
    if (spots.isEmpty) spots = within(widerNear, widerFar);
    if (spots.isEmpty) return null;
    final spot = spots[random.nextInt(spots.length)];
    return Scent(
      target: spot.at,
      environment: spot.environment,
      createdAt: now,
    );
  }

  static bool _between(double d, double a, double b) => d >= a && d <= b;
}
