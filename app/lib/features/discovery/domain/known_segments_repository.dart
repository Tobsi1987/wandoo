/// Merkt sich, welche Straßenabschnitte der Spieler schon kennt.
abstract interface class KnownSegmentsRepository {
  Future<Set<String>> knownIds();

  Future<void> addAll(Set<String> ids);

  /// Meldet die bekannten Abschnitte jetzt und nach jeder Änderung.
  Stream<Set<String>> watchKnownIds();

  /// Vergisst alle Abschnitte: Jede Straße ist wieder neu.
  Future<void> forgetAll();
}
