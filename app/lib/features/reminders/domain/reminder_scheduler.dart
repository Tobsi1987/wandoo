import 'package:wandoo/features/reminders/domain/reminder.dart';

/// Stellt Erinnerungen beim Betriebssystem ein.
abstract interface class ReminderScheduler {
  /// Ersetzt alle vorher geplanten Erinnerungen durch [reminders].
  Future<void> scheduleAll(List<Reminder> reminders);

  /// Nimmt alle geplanten Erinnerungen zurück.
  Future<void> cancel();
}
