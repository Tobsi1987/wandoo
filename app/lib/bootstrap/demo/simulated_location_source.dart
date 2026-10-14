import 'dart:math' as math;

import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/bootstrap/demo/demo_route.dart';
import 'package:wandoo/bootstrap/demo/demo_town.dart';
import 'package:wandoo/core/location/location_source.dart';

/// Spielt für jeden Gang einen zufälligen Rundgang durch die Demo-Stadt ab,
/// im Zeitraffer: ein Messpunkt alle [tick] statt alle paar Sekunden.
class SimulatedLocationSource implements LocationSource {
  SimulatedLocationSource({
    math.Random? random,
    this.tick = const Duration(milliseconds: 60),
    this.goal,
  }) : _random = random ?? math.Random();

  final math.Random _random;
  final Duration tick;

  /// Wohin die Spürnase gerade zieht, falls sie etwas riecht.
  final GeoPoint? Function()? goal;

  @override
  Future<bool> ensurePermission() async => true;

  @override
  Future<GeoPoint?> currentPosition() async => DemoTown.center;

  @override
  Stream<TrackPoint> positions() async* {
    final route = randomRoute(_random, goal: goal?.call());
    final points = sampleRoute(route, _random, start: DateTime.now());
    for (final point in points) {
      await Future<void>.delayed(tick);
      yield point;
    }
  }
}
