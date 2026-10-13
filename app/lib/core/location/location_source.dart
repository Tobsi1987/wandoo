import 'package:geo_engine/geo_engine.dart';

/// Liefert Positionen vom Gerät.
abstract interface class LocationSource {
  /// Fragt bei Bedarf nach der Standortfreigabe. `false`, wenn abgelehnt
  /// oder der Standortdienst aus ist.
  Future<bool> ensurePermission();

  /// Die aktuelle Position, oder `null`, wenn sie nicht ermittelt werden
  /// kann.
  Future<GeoPoint?> currentPosition();

  /// Laufende Positionen, auch bei gesperrtem Bildschirm.
  Stream<TrackPoint> positions();
}
