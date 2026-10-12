import 'package:geo_engine/src/matching/geometry.dart';
import 'package:geo_engine/src/model/geo_point.dart';

/// Füllt Lücken zwischen GPS-Punkten mit Zwischenpunkten alle
/// [stepMeters]. So zählt eine Straße auch bei seltenen Messungen.
///
/// Lücken über [maxGapMeters] (Tunnel, Funkloch, herausgefilterte
/// Autofahrt) werden nicht überbrückt, damit keine Luftlinie durch Häuser
/// als begangen gilt.
Iterable<GeoPoint> densify(
  List<GeoPoint> points, {
  double stepMeters = 5,
  double maxGapMeters = 200,
}) sync* {
  if (points.isEmpty) return;
  yield points.first;
  for (var i = 1; i < points.length; i++) {
    final a = points[i - 1];
    final b = points[i];
    final gap = a.distanceTo(b);
    if (gap > maxGapMeters) {
      yield b;
      continue;
    }
    final steps = (gap / stepMeters).ceil().clamp(1, 1 << 20);
    for (var k = 1; k <= steps; k++) {
      yield interpolate(a, b, k / steps);
    }
  }
}
