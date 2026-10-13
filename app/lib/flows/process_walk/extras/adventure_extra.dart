import 'package:wandoo/features/adventures/adventures.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/treasure/treasure.dart';
import 'package:wandoo/flows/process_walk/walk_extra.dart';

/// Zählt den Gang für die Wochen-Abenteuer und verteilt die Belohnungen:
/// Fundstücke in die Schatzkiste, für alle drei ein Glücks-Ei.
class AdventureExtra implements WalkExtra {
  const AdventureExtra({
    required this.adventures,
    required this.chests,
    required this.creatures,
    this.advance = const AdvanceAdventure(),
  });

  final AdventureRepository adventures;
  final TreasureRepository chests;
  final CreatureRepository creatures;
  final AdvanceAdventure advance;

  @override
  Future<List<String>> onWalk(WalkOutcome outcome) async {
    final step = advance(
      await adventures.load(),
      outcome.newSegmentsByEnvironment,
      outcome.summary.finishedAt,
    );
    await adventures.save(step.adventure);
    if (step.completed.isNotEmpty) {
      final chest = await chests.load();
      await chests.save(chest.add(_rewards(step.completed)));
    }
    if (step.earnedBonus) {
      final creature = await creatures.load();
      await creatures.save(creature.copyWith(luckyEgg: true));
    }
    return [
      for (final q in step.completed) questDoneLine(q),
      if (step.earnedBonus) bonusLine,
    ];
  }

  static List<Find> _rewards(List<Quest> quests) => [
    for (final q in quests)
      ...List.filled(q.rewardCount, Find.rewardFor(q.rewardEnvironment)),
  ];
}
