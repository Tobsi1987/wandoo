/// Merkt sich, welche Straßenabschnitte der Spieler schon kennt.
abstract interface class KnownSegmentsRepository {
  Future<Set<String>> knownIds();

  Future<void> addAll(Set<String> ids);
}
