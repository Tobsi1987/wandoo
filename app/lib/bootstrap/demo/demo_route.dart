import 'dart:math' as math;

import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/bootstrap/demo/demo_town.dart';

/// Ein zufälliger Rundgang über die Kreuzungen der Demo-Stadt, ohne direkt
/// umzukehren. Gibt die Kreuzungen als Wegpunkte zurück.
List<GeoPoint> randomRoute(math.Random random, {int blocks = 12}) {
  const max = DemoTown.size - 1;
  var col = 3;
  var row = 3;
  var last = (-1, -1);
  final points = [DemoTown.node(col, row)];
  for (var i = 0; i < blocks; i++) {
    final options = [
      (col + 1, row),
      (col - 1, row),
      (col, row + 1),
      (col, row - 1),
    ].where((n) => n.$1 >= 0 && n.$1 <= max && n.$2 >= 0 && n.$2 <= max);
    final forward = options.where((n) => n != last).toList();
    final next = forward[random.nextInt(forward.length)];
    last = (col, row);
    (col, row) = next;
    points.add(DemoTown.node(col, row));
  }
  return points;
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
