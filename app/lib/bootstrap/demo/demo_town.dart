import 'dart:math' as math;

import 'package:geo_engine/geo_engine.dart';

/// Erfundene Kleinstadt für die Demo: 7 × 7 Kreuzungen im Abstand von
/// 110 m. Westen Wohngebiet, Mitte Felder, Osten Wald, Norden am Fluss.
abstract final class DemoTown {
  static const origin = GeoPoint(50, 8);
  static const blockMeters = 110.0;
  static const size = 7;

  static GeoPoint get center => node(3, 3);

  /// Kreuzung in Spalte [col] (Ost) und Reihe [row] (Nord).
  static GeoPoint node(num col, num row) {
    const mPerDeg = GeoPoint.earthRadiusMeters * math.pi / 180;
    final lonScale = mPerDeg * math.cos(origin.latitude * math.pi / 180);
    return GeoPoint(
      origin.latitude + row * blockMeters / mPerDeg,
      origin.longitude + col * blockMeters / lonScale,
    );
  }

  static String horizontal(int row, int col) => 'h$row-$col';

  static String vertical(int col, int row) => 'v$col-$row';

  static final List<RoadSegment> segments = [
    for (var r = 0; r < size; r++)
      for (var c = 0; c < size - 1; c++)
        RoadSegment(
          id: horizontal(r, c),
          start: node(c, r),
          end: node(c + 1, r),
          areaTags: _tags(c + 0.5, r.toDouble()),
        ),
    for (var c = 0; c < size; c++)
      for (var r = 0; r < size - 1; r++)
        RoadSegment(
          id: vertical(c, r),
          start: node(c, r),
          end: node(c, r + 1),
          areaTags: _tags(c.toDouble(), r + 0.5),
        ),
  ];

  static Map<String, String> _tags(double col, double row) {
    if (row >= size - 1) return const {'waterway': 'river'};
    if (col >= size - 2) return const {'landuse': 'forest'};
    if (col < 2.5) return const {'landuse': 'residential'};
    return const {'landuse': 'farmland'};
  }
}
