import 'dart:math';

/// Wie viel Erfahrung jedes Level braucht. Die ersten Level kommen fast
/// täglich, später dauert es länger. Bei Level 10 und 25 wird das Wesen
/// eine Stufe größer.
abstract final class LevelCurve {
  static const maxLevel = 30;
  static const stage2At = 10;
  static const stage3At = 25;

  /// Erfahrung von [level] bis zum nächsten.
  static int need(int level) => 70 + 6 * level;

  /// Gesamte Erfahrung, ab der [level] erreicht ist.
  static int xpFor(int level) {
    var sum = 0;
    for (var k = 1; k < min(level, maxLevel); k++) {
      sum += need(k);
    }
    return sum;
  }

  static int levelFor(int xp) {
    var level = 1;
    while (level < maxLevel && xp >= xpFor(level + 1)) {
      level++;
    }
    return level;
  }

  /// Wie weit das nächste Level schon gefüllt ist, 0 bis 1.
  static double towardNext(int xp) {
    final level = levelFor(xp);
    if (level == maxLevel) return 1;
    return (xp - xpFor(level)) / need(level);
  }

  /// Entwicklungsstufe 1, 2 oder 3.
  static int stageFor(int level) => level >= stage3At
      ? 3
      : level >= stage2At
      ? 2
      : 1;
}

/// Woher Erfahrung kommt.
abstract final class Xp {
  /// 10 Erfahrung je 100 m und 5 je neuem Straßenstück.
  static int forWalk({required int meters, required int newSegments}) =>
      meters ~/ 10 + 5 * newSegments;

  /// Wenn die Spürnase einen Fund erschnüffelt hat.
  static const scent = 50;

  /// Je Freundschaftspunkt (Streicheln, gemeinsame Gänge).
  static const perFriendPoint = 5;
}
