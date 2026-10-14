/// Merkt sich, ob die Laute aus sind.
abstract interface class SoundSettingsRepository {
  Future<bool> muted();

  Future<void> setMuted({required bool muted});

  /// Der aktuelle Stand jetzt und nach jeder Änderung.
  Stream<bool> watchMuted();
}
