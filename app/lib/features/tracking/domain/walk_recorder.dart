import 'package:geo_engine/geo_engine.dart';

/// Sammelt die Punkte eines laufenden Gangs.
///
/// Punkte näher als [minStepMeters] am vorigen werden verworfen, damit
/// Stehenbleiben keine Wolke aus GPS-Rauschen erzeugt.
class WalkRecorder {
  WalkRecorder({required this.id, this.minStepMeters = 3});

  /// Setzt einen gesicherten Gang fort.
  factory WalkRecorder.resume(Track track) {
    final recorder = WalkRecorder(id: track.id);
    track.points.forEach(recorder.add);
    return recorder;
  }

  final String id;
  final double minStepMeters;
  final List<TrackPoint> _points = [];
  double _distanceMeters = 0;

  double get distanceMeters => _distanceMeters;

  bool get hasWalk => _points.length >= 2;

  int get pointCount => _points.length;

  /// Wo man gerade ist.
  GeoPoint? get position => _points.lastOrNull?.position;

  /// Ein Punkt etwa [meters] zurück auf dem Weg, für die Gehrichtung.
  GeoPoint? cameFrom({double meters = 15}) {
    final here = position;
    if (here == null) return null;
    for (final p in _points.reversed) {
      if (p.position.distanceTo(here) >= meters) return p.position;
    }
    return null;
  }

  /// Ob die letzten Sekunden schneller als zu Fuß waren (Rad, Bus, Auto).
  bool get tooFast =>
      _points.isNotEmpty &&
      const WalkingFilter().tooFastAt(_points, _points.length - 1);

  void add(TrackPoint point) {
    if (_points.isNotEmpty) {
      final step = _points.last.position.distanceTo(point.position);
      if (step < minStepMeters) return;
      _distanceMeters += step;
    }
    _points.add(point);
  }

  Track finish() => Track(id: id, points: List.unmodifiable(_points));
}
