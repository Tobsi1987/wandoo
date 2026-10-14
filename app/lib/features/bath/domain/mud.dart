import 'dart:math' as math;

import 'package:geo_engine/geo_engine.dart';

/// Wie schmutzig ein Wesen ist: 0 sauber, 3 ganz matschig.
///
/// Nach einem Gang durch Wald oder Feld, und bei Regen sowieso, wird es
/// etwas schmutziger. Im Zuhause wäscht man es wieder sauber.
abstract final class Mud {
  static const max = 3;

  /// Ein paar Schritte vor die Tür machen noch nicht schmutzig.
  static const minMeters = 300;

  /// So viele neue Wald- und Feldstücke machen eine Stufe schmutziger.
  static const muddyStreets = 3;

  /// Wie schmutzig das Wesen nach einem Gang ist.
  static int afterWalk(
    int level, {
    required int meters,
    required Map<EnvironmentType, int> newStreets,
    required bool rainy,
  }) {
    if (meters < minMeters) return level;
    final wild =
        (newStreets[EnvironmentType.forest] ?? 0) +
        (newStreets[EnvironmentType.field] ?? 0);
    final more = (wild >= muddyStreets ? 1 : 0) + (rainy ? 2 : 0);
    return math.min(max, level + more);
  }
}
