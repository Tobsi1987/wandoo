import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/treasure/data/drift_treasure_repository.dart';
import 'package:wandoo/features/treasure/treasure.dart';

import '../../../support/test_database.dart';

void main() {
  test('leere Kiste, wenn noch nichts gespeichert ist', () async {
    final db = testDatabase();
    addTearDown(db.close);
    final chest = await DriftTreasureRepository(db).load();
    expect(chest.finds, isEmpty);
    expect(chest.owned, isEmpty);
  });

  test('speichert Funde und Gebasteltes', () async {
    final db = testDatabase();
    addTearDown(db.close);
    final repo = DriftTreasureRepository(db);
    final chest = const TreasureChest()
        .add([...List.filled(5, Find.poppy), Find.starShard])
        .craft(Accessory.flowerCrown);
    await repo.save(chest);
    final loaded = await repo.load();
    expect(loaded.count(Find.poppy), 1);
    expect(loaded.count(Find.starShard), 1);
    expect(loaded.owned, {Accessory.flowerCrown});
  });
}
