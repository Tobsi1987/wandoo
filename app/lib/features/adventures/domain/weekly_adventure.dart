import 'package:wandoo/features/adventures/domain/quest.dart';

/// Die Abenteuer einer Woche, ab Montag.
class WeeklyAdventure {
  const WeeklyAdventure({
    required this.weekStart,
    required this.quests,
    this.bonusClaimed = false,
  });

  /// Montag 0 Uhr (Ortszeit) der Woche.
  final DateTime weekStart;
  final List<Quest> quests;

  /// Ob das Glücks-Ei für alle Abenteuer schon vergeben ist.
  final bool bonusClaimed;

  bool get allDone => quests.every((q) => q.done);

  int get doneCount => quests.where((q) => q.done).length;

  /// Montag der Woche, in der [time] liegt.
  static DateTime weekOf(DateTime time) =>
      DateTime(time.year, time.month, time.day - (time.weekday - 1));

  bool isWeekOf(DateTime time) => weekStart == weekOf(time);

  WeeklyAdventure copyWith({List<Quest>? quests, bool? bonusClaimed}) =>
      WeeklyAdventure(
        weekStart: weekStart,
        quests: quests ?? this.quests,
        bonusClaimed: bonusClaimed ?? this.bonusClaimed,
      );
}
