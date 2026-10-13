import 'package:geo_engine/geo_engine.dart';
import 'package:meta/meta.dart';

/// Ein Viertel: ein Feld im festen Raster von [sizeDegrees] Grad, rund
/// 1,1 km Nord-Süd und in Mitteleuropa rund 0,7 km Ost-West.
@immutable
class District {
  const District(this.row, this.col);

  factory District.containing(GeoPoint p) => District(
    (p.latitude / sizeDegrees).floor(),
    (p.longitude / sizeDegrees).floor(),
  );

  /// Das Viertel, in dem die Mitte des Abschnitts liegt.
  factory District.of(RoadSegment s) => District.containing(
    GeoPoint(
      (s.start.latitude + s.end.latitude) / 2,
      (s.start.longitude + s.end.longitude) / 2,
    ),
  );

  static const sizeDegrees = 0.01;

  final int row;
  final int col;

  @override
  bool operator ==(Object other) =>
      other is District && other.row == row && other.col == col;

  @override
  int get hashCode => Object.hash(row, col);

  @override
  String toString() => 'District($row, $col)';
}
