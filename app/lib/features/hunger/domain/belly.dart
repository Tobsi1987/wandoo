import 'dart:math';

/// Der Hungerbalken eines Wesens. Voll sind 5 km, jeden Tag wird er um
/// 1 km leerer, und jeder Meter Gehen füllt ihn wieder auf. Ist er zwei
/// Tage lang leer, zieht das Wesen aus.
class Belly {
  const Belly({required this.lineKey, required this.meters, required this.at});

  factory Belly.full(String lineKey, DateTime now) =>
      Belly(lineKey: lineKey, meters: fullMeters, at: now);

  static const double fullMeters = 5000;
  static const double metersPerDay = 1000;
  static const leavesAfter = Duration(days: 2);

  /// Zu welchem Wesen der Balken gehört (`Creature.lineKey`).
  final String lineKey;

  /// Füllstand zum Zeitpunkt [at].
  final double meters;
  final DateTime at;

  double metersAt(DateTime now) {
    final days = now.difference(at).inSeconds / Duration.secondsPerDay;
    return (meters - metersPerDay * max(0, days)).clamp(0, fullMeters);
  }

  /// Zwischen 0 (leer) und 1 (voll).
  double fillAt(DateTime now) => metersAt(now) / fullMeters;

  /// Wann der Balken leer ist (oder war).
  DateTime get emptyAt => at.add(
    Duration(seconds: (meters / metersPerDay * Duration.secondsPerDay).round()),
  );

  bool isEmpty(DateTime now) => metersAt(now) <= 0;

  /// Ab wann das Wesen auszieht, wenn niemand mit ihm geht.
  DateTime get leavesAt => emptyAt.add(leavesAfter);

  bool leavesBy(DateTime now) => !now.isBefore(leavesAt);

  /// Nach einem Gang von [walked] Metern.
  Belly eat(num walked, DateTime now) => Belly(
    lineKey: lineKey,
    meters: min(fullMeters, metersAt(now) + walked),
    at: now,
  );
}
