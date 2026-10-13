import 'dart:math' as math;

import 'package:geo_engine/src/model/geo_point.dart';

const double _metersPerDegLat = GeoPoint.earthRadiusMeters * math.pi / 180;

/// Projiziert [p] auf die Strecke [a]–[b] in einer lokalen Ebene.
///
/// `distance` ist der Abstand in Metern, `t` die Lage des Fußpunkts auf der
/// Strecke (0 = bei [a], 1 = bei [b]). Für Strecken von wenigen hundert
/// Metern genau genug.
({double distance, double t}) projectOntoSegment(
  GeoPoint p,
  GeoPoint a,
  GeoPoint b,
) {
  final metersPerDegLon =
      _metersPerDegLat * math.cos(p.latitude * math.pi / 180);
  final ax = (a.longitude - p.longitude) * metersPerDegLon;
  final ay = (a.latitude - p.latitude) * _metersPerDegLat;
  final dx = (b.longitude - a.longitude) * metersPerDegLon;
  final dy = (b.latitude - a.latitude) * _metersPerDegLat;
  final lengthSquared = dx * dx + dy * dy;
  final t = lengthSquared == 0
      ? 0.0
      : ((-ax * dx - ay * dy) / lengthSquared).clamp(0.0, 1.0);
  final cx = ax + t * dx;
  final cy = ay + t * dy;
  return (distance: math.sqrt(cx * cx + cy * cy), t: t);
}

/// Punkt auf der Strecke [a]–[b] beim Anteil [f] (0 bis 1).
GeoPoint interpolate(GeoPoint a, GeoPoint b, double f) => GeoPoint(
  a.latitude + (b.latitude - a.latitude) * f,
  a.longitude + (b.longitude - a.longitude) * f,
);

/// Meter in Breitengrad umrechnen.
double metersToLatDegrees(double meters) => meters / _metersPerDegLat;

/// Meter in Längengrad umrechnen, abhängig von der Breite.
double metersToLonDegrees(double meters, double latitude) =>
    meters / (_metersPerDegLat * math.cos(latitude * math.pi / 180));
