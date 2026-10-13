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
  const WalkRecording({required this.startedAt, required this.distanceMeters});

  final DateTime startedAt;
  final double distanceMeters;
}
