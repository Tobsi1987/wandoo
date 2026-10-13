import 'package:geo_engine/src/filtering/moving_speed.dart';
import 'package:geo_engine/src/model/track.dart';
import 'package:geo_engine/src/model/track_point.dart';

/// Entfernt Punkte, die nicht zu Fuß oder zu ungenau entstanden sind.
///
/// Ein Punkt fällt weg, wenn
/// - der Gang im Fenster davor schneller als [maxSpeedKmh] war (Gehen und
///   Joggen bleiben, Rad, Bus und Auto fallen raus),
/// - er schneller als [maxJumpKmh] vom vorigen Punkt erreicht wurde
///   (GPS-Sprung), oder
/// - seine Ungenauigkeit über [maxAccuracyMeters] liegt.
class WalkingFilter {
  const WalkingFilter({
    this.maxSpeedKmh = 15,
    this.maxJumpKmh = 40,
    this.maxAccuracyMeters = 40,
    this.speed = const MovingSpeed(),
  });

  final double maxSpeedKmh;
  final double maxJumpKmh;
  final double maxAccuracyMeters;
  final MovingSpeed speed;

  Track apply(Track track) {
    final points = track.points;
    final kept = <TrackPoint>[
      for (var i = 0; i < points.length; i++)
        if (_keep(points, i)) points[i],
    ];
    return Track(id: track.id, points: kept);
  }

  /// Ob gerade zu schnell für einen Gang unterwegs (für Hinweise in der App).
  bool tooFastAt(List<TrackPoint> points, int index) =>
      speed.kmhAt(points, index) > maxSpeedKmh;

  bool _keep(List<TrackPoint> points, int i) {
    final point = points[i];
    if ((point.accuracyMeters ?? 0) > maxAccuracyMeters) return false;
    if (tooFastAt(points, i)) return false;
    return i == 0 || _stepKmh(points[i - 1], point) <= maxJumpKmh;
  }

  double _stepKmh(TrackPoint a, TrackPoint b) {
    final seconds = b.time.difference(a.time).inMilliseconds / 1000;
    if (seconds <= 0) return 0;
    return a.position.distanceTo(b.position) / seconds * 3.6;
  }
}
