import 'package:wandoo/features/reminders/domain/reminder.dart';

/// Stellt Erinnerungen beim Betriebssystem ein. Es gibt höchstens eine.
abstract interface class ReminderScheduler {
  /// Ersetzt eine vorher geplante Erinnerung.
  Future<void> schedule(Reminder reminder);

  Future<void> cancel();
}
