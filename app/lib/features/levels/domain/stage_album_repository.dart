/// Merkt sich für jede Art die höchste Stufe, die je ein Wesen von ihr
/// erreicht hat. Das Sammelalbum zeigt nur diese Stufen in Farbe.
abstract interface class StageAlbumRepository {
  /// Art → höchste erreichte Stufe (2 oder 3).
  Stream<Map<String, int>> watch();

  /// Merkt [stage] für [speciesId], wenn sie höher als die bisherige ist.
  Future<void> reach(String speciesId, int stage);
}
