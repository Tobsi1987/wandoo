import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/levels/data/in_memory_progress_repository.dart';
import 'package:wandoo/features/levels/levels.dart';
import 'package:wandoo/features/treasure/data/in_memory_treasure_repository.dart';
import 'package:wandoo/features/treasure/treasure.dart';
import 'package:wandoo/flows/levels/gain_xp.dart';
import 'package:wandoo/flows/levels/level_rewards.dart';

const _moosel = Creature(food: 30, speciesId: 'moosel');

void main() {
  test('jedes Level bringt etwas, Deko und Sterne an besonderen Leveln', () {
    for (var level = 2; level <= LevelCurve.maxLevel; level++) {
      final r = rewardFor(level);
      expect(
        r.finds.isNotEmpty || r.accessory != null || r.plan != null,
        isTrue,
      );
    }
    expect(rewardFor(5).accessory, Accessory.acornCap);
    expect(rewardFor(3).plan, Accessory.knitScarf);
    expect(rewardFor(10).finds, List.filled(3, Find.starShard));
  });

  test('Aufstieg bis Level 10: Belohnungen in der Kiste, Stufe 2', () async {
    final levels = InMemoryProgressRepository();
    final chests = InMemoryTreasureRepository();
    final gain = GainXp(levels: levels, chests: chests);
    final lines = await gain(_moosel, LevelCurve.xpFor(10));
    expect(lines.first, startsWith('⬆️ Level 2! 🎁 '));
    expect(lines, contains('⬆️ Level 5! 🎁 🎀 Eichelhütchen'));
    expect(lines, contains('⬆️ Level 3! 🎁 📜 Bauplan: Ringelschal'));
    expect(lines.last, '🌟 Moosel ist jetzt Stufe 2!');
    final chest = await chests.load();
    expect(chest.owned, {Accessory.acornCap});
    expect(chest.plans, {Accessory.knitScarf, Accessory.bunnyEars});
    expect(chest.count(Find.starShard), 3 + 2);
    expect((await levels.load('erstes')).news, isEmpty);
  });

  test('beim Streicheln gemerkt, bei Eiern nichts', () async {
    final levels = InMemoryProgressRepository();
    final gain = GainXp(levels: levels, chests: InMemoryTreasureRepository());
    expect(await gain(const Creature(), 500), isEmpty);
    await gain(_moosel, 80, announce: true);
    expect((await levels.load('erstes')).news, hasLength(1));
    await gain(_moosel, 5, announce: true);
    expect((await levels.load('erstes')).news, hasLength(1));
  });
}
