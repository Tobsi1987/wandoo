import 'package:wandoo/features/treasure/domain/treasure_chest.dart';

/// Speichert die Schatzkiste. Die Umsetzung liegt in `data/`.
abstract interface class TreasureRepository {
  Future<TreasureChest> load();

  Future<void> save(TreasureChest chest);

  Stream<TreasureChest> watch();
}
