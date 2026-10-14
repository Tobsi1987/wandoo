/// Merkt sich, nach welchem Gang zuletzt gespielt wurde: einmal je Gang.
abstract interface class StarCatchRepository {
  Future<String?> lastWalk();

  Future<void> playedAfter(String walkId);

  Stream<String?> watchLastWalk();
}
