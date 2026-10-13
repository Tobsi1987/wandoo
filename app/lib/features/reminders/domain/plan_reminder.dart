import 'package:wandoo/features/reminders/domain/reminder.dart';

/// Plant die nächste sanfte Erinnerung: erst wenn das Wesen träge wird,
/// und nur tagsüber. Keine Strafe, kein Druck.
class PlanReminder {
  const PlanReminder({
    this.after = const Duration(days: 3),
    this.earliestHour = 10,
    this.latestHour = 19,
  });

  /// Nach so langer Zeit ohne Neues wird erinnert.
  final Duration after;
  final int earliestHour;

  /// Ab dieser Stunde wird auf den nächsten Morgen verschoben.
  final int latestHour;

  /// `null`, solange das Wesen noch nie gefüttert wurde.
  Reminder? call(DateTime? lastFedAt) {
    if (lastFedAt == null) return null;
    return Reminder(
      at: _daytime(lastFedAt.toLocal().add(after)),
      title: 'Dein Wesen döst',
      body: 'Ein neuer Weg würde es wecken. Ganz ohne Eile.',
    );
  }

  DateTime _daytime(DateTime at) {
    final morning = DateTime(at.year, at.month, at.day, earliestHour);
    if (at.isBefore(morning)) return morning;
    if (at.hour < latestHour) return at;
    return DateTime(at.year, at.month, at.day + 1, earliestHour);
  }
}
