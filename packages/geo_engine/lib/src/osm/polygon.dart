import 'package:geo_engine/src/model/geo_point.dart';

/// Liegt [p] im Ring? Strahlverfahren in Gradkoordinaten, für Flächen
/// von wenigen Kilometern genau genug.
bool ringContains(List<GeoPoint> ring, GeoPoint p) {
  var inside = false;
  for (var i = 0, j = ring.length - 1; i < ring.length; j = i++) {
    final a = ring[i];
    final b = ring[j];
    final crosses =
        (a.latitude > p.latitude) != (b.latitude > p.latitude) &&
        p.longitude <
            (b.longitude - a.longitude) *
                    (p.latitude - a.latitude) /
                    (b.latitude - a.latitude) +
                a.longitude;
    if (crosses) inside = !inside;
  }
  return inside;
}

/// Fläche des Rings in Quadratgrad (nur zum Vergleichen von Größen).
double ringArea(List<GeoPoint> ring) {
  var sum = 0.0;
  for (var i = 0, j = ring.length - 1; i < ring.length; j = i++) {
    sum +=
        (ring[j].longitude - ring[i].longitude) *
        (ring[j].latitude + ring[i].latitude);
  }
  return (sum / 2).abs();
}

/// Achsparalleles Rechteck um Punkte, für schnelle Vorauswahl.
class Bounds {
  Bounds.of(Iterable<GeoPoint> points, {double padDegrees = 0})
    : south = points.map((p) => p.latitude).reduce(_min) - padDegrees,
      north = points.map((p) => p.latitude).reduce(_max) + padDegrees,
      west = points.map((p) => p.longitude).reduce(_min) - padDegrees,
      east = points.map((p) => p.longitude).reduce(_max) + padDegrees;

  final double south;
  final double north;
  final double west;
  final double east;

  bool contains(GeoPoint p) =>
      p.latitude >= south &&
      p.latitude <= north &&
      p.longitude >= west &&
      p.longitude <= east;

  static double _min(double a, double b) => a < b ? a : b;
  static double _max(double a, double b) => a > b ? a : b;
}
