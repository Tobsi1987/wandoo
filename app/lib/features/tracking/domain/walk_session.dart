import 'package:geo_engine/geo_engine.dart';

/// Zustand der Aufzeichnung, so wie die Oberfläche ihn zeigt.
sealed class WalkSession {
  const WalkSession();
}

/// Es wird gerade nicht aufgezeichnet.
class WalkIdle extends WalkSession {
  const WalkIdle({this.permissionDenied = false});

  /// Der letzte Startversuch scheiterte an der Standortfreigabe.
  final bool permissionDenied;
}

/// Ein Gang läuft.
class WalkRecording extends WalkSession {
  const WalkRecording({
    required this.startedAt,
    required this.distanceMeters,
    this.tooFast = false,
    this.position,
    this.cameFrom,
  });

  final DateTime startedAt;
  final double distanceMeters;

  /// Gerade schneller als zu Fuß; solche Strecken zählen nicht.
  final bool tooFast;

  /// Wo man gerade ist, und ein Punkt kurz davor (für die Gehrichtung).
  final GeoPoint? position;
  final GeoPoint? cameFrom;
}
