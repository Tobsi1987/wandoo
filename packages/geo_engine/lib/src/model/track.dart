import 'package:geo_engine/src/model/geo_point.dart';

/// Eine aufgezeichnete GPS-Spur, zum Beispiel ein Spaziergang.
class Track {
  const Track({
    required this.id,
    required this.points,
    required this.startedAt,
  });

  final String id;
  final List<GeoPoint> points;
  final DateTime startedAt;

  bool get isEmpty => points.isEmpty;
}
