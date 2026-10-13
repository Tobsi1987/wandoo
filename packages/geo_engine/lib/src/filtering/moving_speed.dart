import 'package:geo_engine/src/model/track_point.dart';

/// Geschwindigkeit über ein Zeitfenster statt von Punkt zu Punkt.
///
/// Einzelne Messungen springen; über [window] gemittelt lässt sich Joggen
/// zuverlässig von Rad, Bus und Auto trennen.
class MovingSpeed {
  const MovingSpeed({this.window = const Duration(seconds: 30)});

  final Duration window;

  /// Mittlere km/h der Strecke, die in [points] bis einschließlich [index]
  /// innerhalb des Fensters zurückgelegt wurde. Unter 5 s Daten: 0.
  double kmhAt(List<TrackPoint> points, int index) {
    final end = points[index];
    final from = end.time.subtract(window);
    var meters = 0.0;
    var start = index;
    while (start > 0 && !points[start - 1].time.isBefore(from)) {
      meters += points[start - 1].position.distanceTo(points[start].position);
      start--;
    }
    final seconds =
        end.time.difference(points[start].time).inMilliseconds / 1000;
    if (seconds < 5) return 0;
    return meters / seconds * 3.6;
  }
}
