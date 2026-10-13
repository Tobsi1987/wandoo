import 'dart:async';

import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/core/location/location_source.dart';

/// Standortquelle für Tests: Positionen werden von Hand eingespeist.
class FakeLocationSource implements LocationSource {
  FakeLocationSource({this.granted = true, this.current});

  bool granted;
  GeoPoint? current;
  final _controller = StreamController<TrackPoint>.broadcast();

  void emit(TrackPoint point) => _controller.add(point);

  @override
  Future<bool> ensurePermission() async => granted;

  @override
  Future<GeoPoint?> currentPosition() async => current;

  @override
  Stream<TrackPoint> positions() => _controller.stream;
}

/// Punkt [meters] östlich eines festen Ursprungs, [seconds] nach Start.
TrackPoint eastOf(double meters, int seconds) => TrackPoint(
  GeoPoint(50, 8 + meters / 71700),
  DateTime.utc(2026, 10, 13, 8).add(Duration(seconds: seconds)),
);
