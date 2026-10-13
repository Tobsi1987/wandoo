import 'dart:math' as math;

import 'package:geo_engine/geo_engine.dart';

/// Eine erfundene Kleinstadt als Testgelände: 5 × 5 Kreuzungen im Abstand
/// von 100 m. Westlich Wohngebiet, Ostrand Wald, Nordrand am Fluss.
abstract final class SyntheticTown {
  static const origin = GeoPoint(50, 8);
  static const blockMeters = 100.0;
  static const size = 5;

  /// Kreuzung in Spalte [col] (Ost) und Reihe [row] (Nord).
  static GeoPoint node(num col, num row) => offset(
    origin,
    eastMeters: col * blockMeters,
    northMeters: row * blockMeters,
  );

  static GeoPoint offset(
    GeoPoint p, {
    double eastMeters = 0,
    double northMeters = 0,
  }) {
    const mPerDeg = GeoPoint.earthRadiusMeters * math.pi / 180;
    return GeoPoint(
      p.latitude + northMeters / mPerDeg,
      p.longitude +
          eastMeters / (mPerDeg * math.cos(p.latitude * math.pi / 180)),
    );
  }

  /// Horizontale Abschnitte heißen `h<Reihe>-<Spalte>`, vertikale
  /// `v<Spalte>-<Reihe>`.
  static List<RoadSegment> segments() => [
    for (var r = 0; r < size; r++)
      for (var c = 0; c < size - 1; c++)
        RoadSegment(
          id: 'h$r-$c',
          start: node(c, r),
          end: node(c + 1, r),
          areaTags: _tags(c + 0.5, r.toDouble()),
        ),
    for (var c = 0; c < size; c++)
      for (var r = 0; r < size - 1; r++)
        RoadSegment(
          id: 'v$c-$r',
          start: node(c, r),
          end: node(c, r + 1),
          areaTags: _tags(c.toDouble(), r + 0.5),
        ),
  ];

  static Map<String, String> _tags(double col, double row) {
    if (row >= size - 1) return const {'waterway': 'river'};
    if (col >= size - 1) return const {'landuse': 'forest'};
    if (col < 2) return const {'landuse': 'residential'};
    return const {'landuse': 'farmland'};
  }
}

/// Erzeugt eine Spur entlang von [waypoints] mit [speedKmh], einem
/// Messpunkt alle [intervalSeconds] und GPS-Rauschen mit Standardabweichung
/// [noiseMeters]. Deterministisch über [seed].
Track walk(
  String id,
  List<GeoPoint> waypoints, {
  double speedKmh = 5,
  int intervalSeconds = 5,
  double noiseMeters = 4,
  int seed = 1,
}) {
  final random = math.Random(seed);
  double gauss() =>
      math.sqrt(-2 * math.log(1 - random.nextDouble())) *
      math.cos(2 * math.pi * random.nextDouble());
  final stepMeters = speedKmh / 3.6 * intervalSeconds;
  final start = DateTime.utc(2026, 10, 12, 8);
  final points = <TrackPoint>[];
  var travelled = 0.0;
  for (var i = 1; i < waypoints.length; i++) {
    final a = waypoints[i - 1];
    final b = waypoints[i];
    final legLength = a.distanceTo(b);
    var along = points.isEmpty ? 0.0 : (stepMeters - travelled % stepMeters);
    for (; along <= legLength; along += stepMeters) {
      final f = along / legLength;
      final exact = GeoPoint(
        a.latitude + (b.latitude - a.latitude) * f,
        a.longitude + (b.longitude - a.longitude) * f,
      );
      final noisy = SyntheticTown.offset(
        exact,
        eastMeters: gauss() * noiseMeters,
        northMeters: gauss() * noiseMeters,
      );
      final seconds = ((travelled + along) / stepMeters * intervalSeconds)
          .round();
      points.add(TrackPoint(noisy, start.add(Duration(seconds: seconds))));
    }
    travelled += legLength;
  }
  return Track(id: id, points: points);
}
