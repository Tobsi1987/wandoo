import 'package:wandoo/features/levels/levels.dart';
import 'package:wandoo/features/treasure/treasure.dart';

/// Was ein Level bringt: Fundstücke und manchmal Deko.
typedef LevelReward = ({List<Find> finds, Accessory? accessory});

/// Jedes Level bringt etwas. Alle paar Level gibt es Deko, bei den
/// Stufen (10 und 25) viele Sternsplitter.
LevelReward rewardFor(int level) {
  final accessory = switch (level) {
    5 => Accessory.acornCap,
    12 => Accessory.flowerCrown,
    15 => Accessory.shellNecklace,
    20 => Accessory.sparkleScarf,
    LevelCurve.maxLevel => Accessory.starCrown,
    _ => null,
  };
  if (accessory != null) return (finds: const [], accessory: accessory);
  final stars = switch (level) {
    LevelCurve.stage2At => 3,
    LevelCurve.stage3At => 5,
    _ when level % 7 == 0 => 2,
    _ => 0,
  };
  if (stars > 0) {
    return (finds: List.filled(stars, Find.starShard), accessory: null);
  }
  const cycle = [Find.acorn, Find.poppy, Find.shell, Find.sparkle];
  final find = cycle[level % cycle.length];
  return (finds: List.filled(2 + level ~/ 10, find), accessory: null);
}

/// Legt die Belohnung in die Kiste. Schon vorhandene Deko gibt es als
/// Fundstücke, aus denen man sie basteln könnte.
(TreasureChest, List<String>) giveReward(TreasureChest chest, int level) {
  final reward = rewardFor(level);
  final a = reward.accessory;
  if (a != null && !chest.owned.contains(a)) {
    return (chest.gift(a), ['🎀 ${accessoryName(a)}']);
  }
  final finds = a == null ? reward.finds : List.filled(a.cost, a.material);
  return (chest.add(finds), foundLines(finds));
}
