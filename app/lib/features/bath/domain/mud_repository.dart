/// Speichert, wie schmutzig jedes Wesen ist (`Creature.lineKey`).
abstract interface class MudRepository {
  /// 0 für ein Wesen, das nie schmutzig war.
  Future<int> load(String lineKey);

  Future<void> save(String lineKey, int level);

  Stream<int> watch(String lineKey);
}
