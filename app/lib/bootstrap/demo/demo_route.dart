import 'dart:math' as math;

import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/bootstrap/demo/demo_town.dart';

/// Ein zufälliger Rundgang über die Kreuzungen der Demo-Stadt, ohne direkt
/// umzukehren. Gibt die Kreuzungen als Wegpunkte zurück.
///
/// Mit [goal] (der Spürnase) geht es meist in dessen Richtung, bis man
/// dort war, wie ein Kind, das der Nase folgt.
List<GeoPoint> randomRoute(
  math.Random random, {
  int blocks = 12,
  GeoPoint? goal,
}) {
  const max = DemoTown.size - 1;
  var col = 3;
  var row = 3;
  var last = (-1, -1);
  final points = [DemoTown.node(col, row)];
  var seek = goal;
  for (var i = 0; i < blocks; i++) {
    final options = [
      (col + 1, row),
      (col - 1, row),
      (col, row + 1),
      (col, row - 1),
    ].where((n) => n.$1 >= 0 && n.$1 <= max && n.$2 >= 0 && n.$2 <= max);
    final forward = options.where((n) => n != last).toList();
    final target = seek;
    final next = target != null && random.nextDouble() < 0.8
        ? _closest(forward, target)
        : forward[random.nextInt(forward.length)];
    last = (col, row);
    (col, row) = next;
    points.add(DemoTown.node(col, row));
    if (target != null && _passed(points, target)) seek = null;
  }
  return points;
}

(int, int) _closest(List<(int, int)> options, GeoPoint goal) => options.reduce(
  (a, b) =>
      DemoTown.node(a.$1, a.$2).distanceTo(goal) <=
          DemoTown.node(b.$1, b.$2).distanceTo(goal)
      ? a
      : b,
);

/// Ob der letzte Block an [goal] vorbeiführte (Mitte oder Ende).
bool _passed(List<GeoPoint> points, GeoPoint goal) {
  final a = points[points.length - 2];
  final b = points.last;
  final mid = GeoPoint(
    (a.latitude + b.latitude) / 2,
    (a.longitude + b.longitude) / 2,
  );
  return mid.distanceTo(goal) < 20 || b.distanceTo(goal) < 20;
}

/// Messpunkte entlang [waypoints]: alle [stepMeters] einer, mit etwas
/// GPS-Rauschen, Zeitstempel wie bei 5 km/h.
List<TrackPoint> sampleRoute(
  List<GeoPoint> waypoints,
  math.Random random, {
  required DateTime start,
  double stepMeters = 7,
}) {
  const secondsPerMeter = 3.6 / 5;
  final points = <TrackPoint>[];
  var travelled = 0.0;
  for (var i = 1; i < waypoints.length; i++) {
    final a = waypoints[i - 1];
    final b = waypoints[i];
    final length = a.distanceTo(b);
    for (var along = 0.0; along < length; along += stepMeters) {
      final f = along / length;
      final jitter = (random.nextDouble() - 0.5) * 0.00006;
      final seconds = ((travelled + along) * secondsPerMeter).round();
      points.add(
        TrackPoint(
          GeoPoint(
            a.latitude + (b.latitude - a.latitude) * f + jitter,
            a.longitude + (b.longitude - a.longitude) * f + jitter,
          ),
          start.add(Duration(seconds: seconds)),
        ),
      );
    }
    travelled += length;
  }
  return points;
}
