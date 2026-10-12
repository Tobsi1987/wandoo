import 'package:geo_engine/src/model/geo_point.dart';

/// Ein einzelner GPS-Messpunkt einer Spur.
class TrackPoint {
  const TrackPoint(this.position, this.time, {this.accuracyMeters});

  final GeoPoint position;
  final DateTime time;

  /// Ungenauigkeit laut Gerät (Radius in Metern), falls bekannt.
  final double? accuracyMeters;
}
