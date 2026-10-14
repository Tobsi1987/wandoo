import 'package:wandoo/features/achievements/domain/lifetime_stats.dart';

/// Wie weit ein Stempel ist: noch nicht, Bronze, Silber oder Gold.
enum Tier { none, bronze, silver, gold }

/// Alles, woraus die Stempel berechnet werden.
class AchievementInputs {
  const AchievementInputs({
    this.stats = const LifetimeStats(),
    this.speciesSeen = 0,
    this.level = 0,
  });

  final LifetimeStats stats;
  final int speciesSeen;
  final int level;
}

/// Ein Stempel im Erfolge-Buch. Er bringt nichts, er erinnert nur.
class Achievement {
  const Achievement({
    required this.id,
    required this.emoji,
    required this.title,
    required this.what,
    required this.steps,
    required this.value,
    this.unit = '',
  });

  final String id;
  final String emoji;
  final String title;

  /// Was man dafür tut, zum Beispiel "Kilometer gelaufen".
  final String what;

  /// Schwellen für Bronze, Silber und Gold.
  final List<int> steps;
  final int Function(AchievementInputs inputs) value;

  /// Hinter der Zahl, zum Beispiel " km".
  final String unit;

  Tier tierFor(AchievementInputs inputs) {
    final v = value(inputs);
    var tier = Tier.none;
    for (var i = 0; i < steps.length; i++) {
      if (v >= steps[i]) tier = Tier.values[i + 1];
    }
    return tier;
  }
}

/// Eine Seite im Buch mit ihren Stempeln.
class AchievementPage {
  const AchievementPage(this.title, this.achievements);

  final String title;
  final List<Achievement> achievements;
}
