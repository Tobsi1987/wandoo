import 'package:geo_engine/src/model/geo_point.dart';
import 'package:geo_engine/src/model/track_point.dart';

/// Eine aufgezeichnete GPS-Spur, zum Beispiel ein Spaziergang.
class Track {
  const Track({required this.id, required this.points});

  final String id;
  final List<TrackPoint> points;

  bool get isEmpty => points.isEmpty;

  DateTime? get startedAt => isEmpty ? null : points.first.time;

  List<GeoPoint> get positions => [for (final p in points) p.position];
}
