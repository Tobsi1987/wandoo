import 'package:wandoo/features/achievements/domain/achievement.dart';
import 'package:wandoo/features/achievements/domain/achievement_catalog.dart';

/// Zeilen für jeden Stempel, der zwischen [before] und [after] eine Stufe
/// höher gekommen ist.
List<String> newStamps(AchievementInputs before, AchievementInputs after) => [
  for (final a in AchievementCatalog.all)
    if (a.tierFor(after).index > a.tierFor(before).index) _line(a, after),
];

String _line(Achievement a, AchievementInputs inputs) =>
    '📖 Neuer Stempel: ${a.emoji} ${a.title} in ${tierName(a.tierFor(inputs))}';

String tierName(Tier tier) => switch (tier) {
  Tier.none => 'noch offen',
  Tier.bronze => 'Bronze',
  Tier.silver => 'Silber',
  Tier.gold => 'Gold',
};
