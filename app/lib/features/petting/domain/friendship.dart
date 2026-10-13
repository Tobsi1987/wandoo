/// Wie sehr das Wesen dich mag. Gilt für ein Wesen vom Ei bis zum
/// Wegschicken (`creatureKey`), danach fängt das neue bei null an.
class Friendship {
  const Friendship({
    required this.creatureKey,
    this.points = 0,
    this.petsToday = 0,
    this.petDay,
  });

  /// Ab so vielen Punkten leuchtet jeweils ein Herz mehr.
  static const heartsAt = [10, 30, 60, 100, 160];

  final String creatureKey;
  final int points;

  /// Gezählte Streicheleinheiten am Tag [petDay].
  final int petsToday;
  final DateTime? petDay;

  /// 0 bis 5 volle Herzen.
  int get hearts => heartsAt.where((p) => points >= p).length;

  /// Wie weit das nächste Herz schon gefüllt ist, 0 bis 1.
  double get towardNext {
    if (hearts == heartsAt.length) return 1;
    final from = hearts == 0 ? 0 : heartsAt[hearts - 1];
    return (points - from) / (heartsAt[hearts] - from);
  }

  Friendship copyWith({int? points, int? petsToday, DateTime? petDay}) =>
      Friendship(
        creatureKey: creatureKey,
        points: points ?? this.points,
        petsToday: petsToday ?? this.petsToday,
        petDay: petDay ?? this.petDay,
      );
}
