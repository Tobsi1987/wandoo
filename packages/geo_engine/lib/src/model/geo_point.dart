import 'dart:math' as math;

import 'package:meta/meta.dart';

/// Ein Punkt auf der Erde in WGS84-Koordinaten.
@immutable
class GeoPoint {
  const GeoPoint(this.latitude, this.longitude);

  final double latitude;
  final double longitude;

  static const double earthRadiusMeters = 6371000;

  /// Entfernung in Metern (Haversine-Formel).
  double distanceTo(GeoPoint other) {
    final dLat = _rad(other.latitude - latitude);
    final dLon = _rad(other.longitude - longitude);
    final a =
        math.pow(math.sin(dLat / 2), 2) +
        math.cos(_rad(latitude)) *
            math.cos(_rad(other.latitude)) *
            math.pow(math.sin(dLon / 2), 2);
    return 2 * earthRadiusMeters * math.asin(math.sqrt(a));
  }

  static double _rad(double degrees) => degrees * math.pi / 180;

  @override
  bool operator ==(Object other) =>
      other is GeoPoint &&
      other.latitude == latitude &&
      other.longitude == longitude;

  @override
  int get hashCode => Object.hash(latitude, longitude);

  @override
  String toString() => 'GeoPoint($latitude, $longitude)';
}
