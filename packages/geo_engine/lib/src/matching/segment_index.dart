import 'dart:math' as math;

import 'package:geo_engine/src/matching/geometry.dart';
import 'package:geo_engine/src/model/geo_point.dart';
import 'package:geo_engine/src/model/road_segment.dart';

/// Rasterindex, damit pro GPS-Punkt nur nahe Abschnitte geprüft werden.
///
/// Jeder Abschnitt wird in alle Zellen eingetragen, die sein Rahmen plus
/// `paddingMeters` berührt.
class SegmentIndex {
  SegmentIndex(
    List<RoadSegment> segments, {
    double cellMeters = 100,
    double paddingMeters = 25,
  }) : _refLat = segments.isEmpty ? 0 : segments.first.start.latitude,
       _cellLat = metersToLatDegrees(cellMeters) {
    _cellLon = metersToLonDegrees(cellMeters, _refLat);
    for (final segment in segments) {
      _insert(segment, paddingMeters);
    }
  }

  final double _refLat;
  final double _cellLat;
  late final double _cellLon;
  final Map<(int, int), List<RoadSegment>> _cells = {};

  /// Abschnitte, die in der Zelle von [point] eingetragen sind.
  List<RoadSegment> near(GeoPoint point) =>
      _cells[_cellOf(point.latitude, point.longitude)] ?? const [];

  (int, int) _cellOf(double lat, double lon) =>
      ((lat / _cellLat).floor(), (lon / _cellLon).floor());

  void _insert(RoadSegment s, double padding) {
    final padLat = metersToLatDegrees(padding);
    final padLon = metersToLonDegrees(padding, _refLat);
    final lo = _cellOf(
      math.min(s.start.latitude, s.end.latitude) - padLat,
      math.min(s.start.longitude, s.end.longitude) - padLon,
    );
    final hi = _cellOf(
      math.max(s.start.latitude, s.end.latitude) + padLat,
      math.max(s.start.longitude, s.end.longitude) + padLon,
    );
    for (var i = lo.$1; i <= hi.$1; i++) {
      for (var j = lo.$2; j <= hi.$2; j++) {
        _cells.putIfAbsent((i, j), () => []).add(s);
      }
    }
  }
}
