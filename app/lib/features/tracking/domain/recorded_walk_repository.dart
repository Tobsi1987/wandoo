import 'package:geo_engine/geo_engine.dart';

/// Fertig aufgezeichnete Gänge, bis sie verarbeitet sind.
///
/// So geht kein Gang verloren, auch wenn beim Beenden keine Kartendaten
/// geladen werden können (zum Beispiel offline).
abstract interface class RecordedWalkRepository {
  Future<void> saveFinished(Track track);

  /// Sichert einen laufenden Gang zwischendurch, damit er ein Beenden der
  /// App übersteht. Zählt nicht als offen zur Verarbeitung.
  Future<void> saveProgress(Track track);

  /// Der zuletzt gesicherte, noch laufende Gang, falls es einen gibt.
  Future<Track?> unfinished();

  /// Verwirft einen laufenden Gang ganz.
  Future<void> discard(String trackId);

  /// Gänge, die noch nicht verarbeitet wurden, ältester zuerst.
  Future<List<Track>> pending();

  /// Meldet sich bei jeder Änderung der offenen Gänge.
  Stream<int> watchPendingCount();

  Future<void> markProcessed(String trackId);
}
