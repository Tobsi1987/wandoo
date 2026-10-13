import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/creature/data/drift_creature_repository.dart';

import '../../../support/test_database.dart';

void main() {
  test('ohne Eintrag gibt es ein frisches Ei', () async {
    final db = testDatabase();
    addTearDown(db.close);
    final creature = await DriftCreatureRepository(db).load();
    expect(creature.food, 0);
    expect(creature.stage, GrowthStage.egg);
  });

  test('speichert und lädt Futter, Merkmale und Fütterungszeit', () async {
    final db = testDatabase();
    addTearDown(db.close);
    final repo = DriftCreatureRepository(db);
    final fedAt = DateTime(2026, 10, 12, 9);
    await repo.save(
      Creature(
        food: 7,
        traitPoints: const {Trait.moss: 5, Trait.fins: 2},
        lastFedAt: fedAt,
      ),
    );
    await repo.save(
      Creature(food: 9, traitPoints: const {Trait.moss: 7}, lastFedAt: fedAt),
    );
    final loaded = await repo.load();
    expect(loaded.food, 9);
    expect(loaded.traitPoints, {Trait.moss: 7});
    expect(loaded.lastFedAt, fedAt);
  });

  test('merkt sich Tierart und letztes Wegschicken', () async {
    final db = testDatabase();
    addTearDown(db.close);
    final repo = DriftCreatureRepository(db);
    final released = DateTime(2026, 10, 2);
    await repo.save(
      Creature(food: 30, speciesId: 'waschbaer', lastReleasedAt: released),
    );
    final loaded = await repo.load();
    expect(loaded.speciesId, 'waschbaer');
    expect(loaded.lastReleasedAt, released);
  });

  test('merkt sich Deko, Album und Glücks-Ei', () async {
    final db = testDatabase();
    addTearDown(db.close);
    final repo = DriftCreatureRepository(db);
    await repo.save(
      const Creature(
        food: 30,
        hat: CreatureHat.flowerCrown,
        neck: CreatureNeck.shellNecklace,
        seenSpecies: {'axolotl'},
        luckyEgg: true,
      ),
    );
    final loaded = await repo.load();
    expect(loaded.hat, CreatureHat.flowerCrown);
    expect(loaded.neck, CreatureNeck.shellNecklace);
    expect(loaded.seenSpecies, {'axolotl'});
    expect(loaded.luckyEgg, isTrue);
  });
}
