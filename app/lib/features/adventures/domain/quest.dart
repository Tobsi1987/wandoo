import 'package:geo_engine/geo_engine.dart';

/// Was für ein Abenteuer zählt.
enum QuestKind {
  /// Neue Abschnitte, egal wo.
  newSegments,

  /// Neue Abschnitte in einer bestimmten Umgebung.
  newInEnvironment,

  /// Gänge mit mindestens einem neuen Abschnitt.
  discoveryWalks,

  /// Ein einzelner Gang mit vielen neuen Abschnitten.
  bigWalk,
}

/// Ein Wochen-Abenteuer mit Ziel, Fortschritt und Belohnung.
///
/// Die Belohnung sind Fundstücke aus [rewardEnvironment]; ohne Umgebung
/// ist es ein Sternsplitter.
class Quest {
  const Quest({
    required this.kind,
    required this.goal,
    this.environment,
    this.progress = 0,
    this.rewardEnvironment,
    this.rewardCount = 1,
  });

  final QuestKind kind;
  final int goal;
  final EnvironmentType? environment;
  final int progress;
  final EnvironmentType? rewardEnvironment;
  final int rewardCount;

  bool get done => progress >= goal;

  double get fraction => (progress / goal).clamp(0, 1).toDouble();

  /// Zählt einen Gang mit diesen neuen Abschnitten je Umgebung.
  Quest advance(Map<EnvironmentType, int> fresh) {
    if (done) return this;
    final total = fresh.values.fold(0, (a, b) => a + b);
    final step = switch (kind) {
      QuestKind.newSegments => total,
      QuestKind.newInEnvironment => fresh[environment] ?? 0,
      QuestKind.discoveryWalks => total > 0 ? 1 : 0,
      QuestKind.bigWalk => total >= goal ? goal : 0,
    };
    return _withProgress((progress + step).clamp(0, goal));
  }

  Quest _withProgress(int value) => Quest(
    kind: kind,
    goal: goal,
    environment: environment,
    progress: value,
    rewardEnvironment: rewardEnvironment,
    rewardCount: rewardCount,
  );
}
