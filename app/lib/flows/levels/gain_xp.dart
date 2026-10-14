import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/levels/levels.dart';
import 'package:wandoo/features/treasure/treasure.dart';
import 'package:wandoo/flows/levels/level_rewards.dart';

/// Gibt einem geschlüpften Wesen Erfahrung. Für jedes neue Level kommt
/// die Belohnung in die Schatzkiste.
class GainXp {
  GainXp({required this.levels, required this.chests});

  final ProgressRepository levels;
  final TreasureRepository chests;

  /// Gibt die Zeilen zu neuen Leveln zurück. Mit [announce] werden sie
  /// auch als Nachricht für den Startbildschirm gemerkt (wenn keine
  /// Zusammenfassung sie zeigt).
  Future<List<String>> call(
    Creature creature,
    int xp, {
    bool announce = false,
  }) async {
    if (!creature.hatched || xp <= 0) return const [];
    final before = await levels.load(creature.lineKey);
    final after = before.copyWith(xp: before.xp + xp);
    final lines = await _rewards(creature, before.level, after.level);
    await levels.save(
      announce && lines.isNotEmpty
          ? after.copyWith(news: [...after.news, ...lines])
          : after,
    );
    return lines;
  }

  Future<List<String>> _rewards(Creature creature, int from, int to) async {
    if (to <= from) return const [];
    final name = SpeciesCatalog.byId(creature.speciesId).name;
    var chest = await chests.load();
    final lines = <String>[];
    for (var level = from + 1; level <= to; level++) {
      final (next, gifts) = giveReward(chest, level);
      chest = next;
      lines.add('⬆️ Level $level! 🎁 ${gifts.join(', ')}');
      final stage = LevelCurve.stageFor(level);
      if (stage > LevelCurve.stageFor(level - 1)) {
        lines.add('🌟 $name ist jetzt Stufe $stage!');
      }
      if (level == LevelCurve.stage3At) {
        lines.add('🥚 In der Höhle wartet ein zweites Ei!');
      }
    }
    await chests.save(chest);
    return lines;
  }
}
