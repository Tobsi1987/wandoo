import 'dart:developer' as developer;

import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/reminders/reminders.dart';

/// Hält die Erinnerung passend zum Wesen: jede Fütterung verschiebt sie.
class SyncCreatureReminder {
  SyncCreatureReminder({
    required this.plan,
    required this.scheduler,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final PlanReminder plan;
  final ReminderScheduler scheduler;
  final DateTime Function() _clock;
  DateTime? _handledFedAt;

  Future<void> call(Creature creature) async {
    final fedAt = creature.lastFedAt;
    if (fedAt == null || fedAt == _handledFedAt) return;
    _handledFedAt = fedAt;
    final reminder = plan(fedAt);
    try {
      if (reminder == null || reminder.at.isBefore(_clock())) {
        await scheduler.cancel();
      } else {
        await scheduler.schedule(reminder);
      }
    } on Object catch (error, stack) {
      developer.log(
        'Erinnerung konnte nicht geplant werden.',
        name: 'wandoo.creature_reminder',
        error: error,
        stackTrace: stack,
      );
    }
  }
}
