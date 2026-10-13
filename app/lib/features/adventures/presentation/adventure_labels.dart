import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/adventures/domain/quest.dart';
import 'package:wandoo/features/treasure/treasure.dart';

/// Aufgabe eines Abenteuers, z. B. "Entdecke 8 neue Waldwege".
String questLabel(Quest q) => switch (q.kind) {
  QuestKind.newSegments => 'Entdecke ${q.goal} neue Wegstücke',
  QuestKind.newInEnvironment =>
    'Entdecke ${q.goal} neue ${_ways(q.environment)}',
  QuestKind.discoveryWalks => 'Geh ${q.goal}-mal auf Entdeckungstour',
  QuestKind.bigWalk => 'Entdecke ${q.goal} neue Wegstücke auf einem Gang',
};

/// "🌰 3 Eicheln"
String rewardLabel(Quest q) {
  final find = Find.rewardFor(q.rewardEnvironment);
  final (one, many) = findNames(find);
  return '${findEmoji(find)} ${q.rewardCount} '
      '${q.rewardCount == 1 ? one : many}';
}

/// Zeile für die Zusammenfassung nach einem Gang.
String questDoneLine(Quest q) =>
    'Abenteuer geschafft: ${questLabel(q)}. Belohnung: ${rewardLabel(q)}';

const bonusLine =
    'Alle Wochen-Abenteuer geschafft! Dein nächstes Ei ist ein Glücks-Ei.';

String _ways(EnvironmentType? place) => switch (place) {
  EnvironmentType.forest => 'Waldwege',
  EnvironmentType.water => 'Wege am Wasser',
  EnvironmentType.city => 'Stadtstraßen',
  EnvironmentType.field => 'Feldwege',
  EnvironmentType.unknown || null => 'Wege',
};
