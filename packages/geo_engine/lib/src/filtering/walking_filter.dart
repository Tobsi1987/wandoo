import 'package:geo_engine/src/model/track.dart';
import 'package:geo_engine/src/model/track_point.dart';

/// Entfernt Punkte, die nicht zu Fuß oder zu ungenau entstanden sind.
///
/// Ein Punkt fällt weg, wenn er schneller als [maxSpeedKmh] vom vorigen
/// Messpunkt erreicht wurde (Auto, Bahn, GPS-Sprung) oder seine
/// Ungenauigkeit über [maxAccuracyMeters] liegt.
class WalkingFilter {
  const WalkingFilter({this.maxSpeedKmh = 25, this.maxAccuracyMeters = 40});

  final double maxSpeedKmh;
  final double maxAccuracyMeters;

  Track apply(Track track) {
    final kept = <TrackPoint>[];
    TrackPoint? previous;
    for (final point in track.points) {
      final tooFast =
          previous != null && _speedKmh(previous, point) > maxSpeedKmh;
      final tooVague = (point.accuracyMeters ?? 0) > maxAccuracyMeters;
      if (!tooFast && !tooVague) kept.add(point);
      previous = point;
    }
    return Track(id: track.id, points: kept);
  }

  double _speedKmh(TrackPoint a, TrackPoint b) {
    final seconds = b.time.difference(a.time).inMilliseconds / 1000;
    if (seconds <= 0) return 0;
    return a.position.distanceTo(b.position) / seconds * 3.6;
  }
}
