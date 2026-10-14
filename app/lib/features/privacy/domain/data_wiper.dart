/// Löscht alles, was die App auf dem Gerät gespeichert hat.
abstract interface class DataWiper {
  Future<void> wipeAll();
}
