import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/adventures/domain/plan_week.dart';
import 'package:wandoo/features/adventures/domain/quest.dart';
import 'package:wandoo/features/adventures/domain/weekly_adventure.dart';

/// Was ein Gang für die Abenteuer gebracht hat.
class AdventureStep {
  const AdventureStep({
    required this.adventure,
    required this.completed,
    required this.earnedBonus,
  });

  final WeeklyAdventure adventure;

  /// Abenteuer, die genau mit diesem Gang geschafft wurden.
  final List<Quest> completed;

  /// Alle Abenteuer der Woche geschafft: Es gibt ein Glücks-Ei.
  final bool earnedBonus;
}

/// Zählt einen Gang für die Abenteuer der Woche. Ist eine neue Woche
/// angebrochen, beginnen neue Abenteuer.
class AdvanceAdventure {
  const AdvanceAdventure({this.plan = const PlanWeek()});

  final PlanWeek plan;

  AdventureStep call(
    WeeklyAdventure? current,
    Map<EnvironmentType, int> fresh,
    DateTime now,
  ) {
    final week = current != null && current.isWeekOf(now) ? current : plan(now);
    final quests = [for (final q in week.quests) q.advance(fresh)];
    final completed = [
      for (var i = 0; i < quests.length; i++)
        if (quests[i].done && !week.quests[i].done) quests[i],
    ];
    var next = week.copyWith(quests: quests);
    final bonus = next.allDone && !next.bonusClaimed;
    if (bonus) next = next.copyWith(bonusClaimed: true);
    return AdventureStep(
      adventure: next,
      completed: completed,
      earnedBonus: bonus,
    );
  }
}
