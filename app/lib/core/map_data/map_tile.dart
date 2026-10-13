import 'package:geo_engine/geo_engine.dart';
import 'package:meta/meta.dart';

/// Eine Kachel im festen Raster von [sizeDegrees] Grad.
///
/// Kartendaten werden kachelweise geladen und gespeichert. Ein externer
/// Dienst erfährt dabei nur, welche grobe Kachel gebraucht wird, nie die
/// genaue Spur.
@immutable
class MapTile {
  const MapTile(this.row, this.col);

  factory MapTile.containing(GeoPoint p) => MapTile(
    (p.latitude / sizeDegrees).floor(),
    (p.longitude / sizeDegrees).floor(),
  );

  /// Rund 5,5 km Nord-Süd, in Mitteleuropa rund 3,5 km Ost-West.
  static const sizeDegrees = 0.05;

  final int row;
  final int col;

  double get south => row * sizeDegrees;
  double get west => col * sizeDegrees;
  double get north => south + sizeDegrees;
  double get east => west + sizeDegrees;

  String get key => 't${row}_$col';

  bool contains(GeoPoint p) => MapTile.containing(p) == this;

  /// Alle Kacheln, die das Rechteck um [points] plus [padDegrees] berühren.
  static Set<MapTile> covering(
    Iterable<GeoPoint> points, {
    double padDegrees = 0,
  }) {
    if (points.isEmpty) return const {};
    final tiles = [
      for (final p in points)
        for (final d in [-padDegrees, padDegrees])
          MapTile.containing(GeoPoint(p.latitude + d, p.longitude + d)),
    ];
    final rows = tiles.map((t) => t.row);
    final cols = tiles.map((t) => t.col);
    return {
      for (var r = rows.reduce(_min); r <= rows.reduce(_max); r++)
        for (var c = cols.reduce(_min); c <= cols.reduce(_max); c++)
          MapTile(r, c),
    };
  }

  static int _min(int a, int b) => a < b ? a : b;
  static int _max(int a, int b) => a > b ? a : b;

  @override
  bool operator ==(Object other) =>
      other is MapTile && other.row == row && other.col == col;

  @override
  int get hashCode => Object.hash(row, col);
}
