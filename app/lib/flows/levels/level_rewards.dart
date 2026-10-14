import 'package:wandoo/features/levels/levels.dart';
import 'package:wandoo/features/treasure/treasure.dart';

/// Was ein Level bringt: Fundstücke, manchmal Deko oder ein Bauplan.
typedef LevelReward = ({
  List<Find> finds,
  Accessory? accessory,
  Accessory? plan,
});

/// Bei welchem Level es welchen Bauplan gibt, vom leichtesten zum
/// schwersten Teil.
const Map<int, Accessory> planLevels = {
  3: Accessory.knitScarf,
  8: Accessory.bunnyEars,
  11: Accessory.antlers,
  16: Accessory.pearlNecklace,
  19: Accessory.topHat,
  23: Accessory.medal,
  26: Accessory.wizardHat,
  27: Accessory.cape,
  29: Accessory.starHalo,
  LevelCurve.maxLevel: Accessory.starCrown,
};

/// Jedes Level bringt etwas. Alle paar Level gibt es Deko oder einen
/// Bauplan, bei den Stufen (10 und 25) viele Sternsplitter.
LevelReward rewardFor(int level) {
  final accessory = switch (level) {
    5 => Accessory.acornCap,
    12 => Accessory.flowerCrown,
    15 => Accessory.shellNecklace,
    20 => Accessory.sparkleScarf,
    _ => null,
  };
  if (accessory != null) {
    return (finds: const [], accessory: accessory, plan: null);
  }
  final plan = planLevels[level];
  if (plan != null) return (finds: const [], accessory: null, plan: plan);
  final stars = switch (level) {
    LevelCurve.stage2At => 3,
    LevelCurve.stage3At => 5,
    _ when level % 7 == 0 => 2,
    _ => 0,
  };
  if (stars > 0) {
    return (
      finds: List.filled(stars, Find.starShard),
      accessory: null,
      plan: null,
    );
  }
  const cycle = [Find.acorn, Find.poppy, Find.shell, Find.sparkle];
  final find = cycle[level % cycle.length];
  return (
    finds: List.filled(2 + level ~/ 10, find),
    accessory: null,
    plan: null,
  );
}

/// Legt die Belohnung in die Kiste. Schon vorhandene Deko gibt es als
/// Fundstücke, aus denen man sie basteln könnte.
(TreasureChest, List<String>) giveReward(TreasureChest chest, int level) {
  final reward = rewardFor(level);
  final plan = reward.plan;
  if (plan != null && !chest.plans.contains(plan)) {
    return (chest.learn(plan), ['📜 Bauplan: ${accessoryName(plan)}']);
  }
  final a = reward.accessory;
  if (a != null && !chest.owned.contains(a)) {
    return (chest.gift(a), ['🎀 ${accessoryName(a)}']);
  }
  final finds = [
    ...reward.finds,
    for (final e in (a ?? plan)?.recipe.entries ?? <MapEntry<Find, int>>[])
      ...List.filled(e.value, e.key),
  ];
  return (chest.add(finds), foundLines(finds));
}
