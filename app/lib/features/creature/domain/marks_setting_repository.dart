/// Merkt sich, ob das Wesen die Spuren der Welt zeigt oder normal aussieht.
abstract interface class MarksSettingRepository {
  /// Der aktuelle Stand jetzt und nach jeder Änderung; anfangs an.
  Stream<bool> watchShown();

  Future<void> setShown({required bool shown});
}
