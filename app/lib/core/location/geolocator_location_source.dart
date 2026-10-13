import 'package:flutter/foundation.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wandoo/core/location/location_source.dart';

/// Standort über das Paket geolocator.
///
/// Android: Vordergrunddienst mit Benachrichtigung, solange aufgezeichnet
/// wird. iOS: Hintergrundmodus "location" mit blauer Statusleiste.
class GeolocatorLocationSource implements LocationSource {
  const GeolocatorLocationSource();

  @override
  Future<bool> ensurePermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) return false;
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  @override
  Stream<TrackPoint> positions() => Geolocator.getPositionStream(
    locationSettings: _settings(),
  ).map(_toTrackPoint);

  static TrackPoint _toTrackPoint(Position p) => TrackPoint(
    GeoPoint(p.latitude, p.longitude),
    p.timestamp,
    accuracyMeters: p.accuracy,
  );

  static LocationSettings _settings() {
    const distanceFilter = 5;
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => AndroidSettings(
        distanceFilter: distanceFilter,
        intervalDuration: const Duration(seconds: 5),
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationTitle: 'Wandoo ist unterwegs',
          notificationText: 'Dein Weg wird aufgezeichnet.',
          enableWakeLock: true,
        ),
      ),
      TargetPlatform.iOS => AppleSettings(
        distanceFilter: distanceFilter,
        activityType: ActivityType.fitness,
        // Standard: Hintergrund an, automatische Pause aus.
        showBackgroundLocationIndicator: true,
      ),
      _ => const LocationSettings(distanceFilter: distanceFilter),
    };
  }
}
