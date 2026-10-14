import 'dart:developer' as developer;

import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/reminders/reminders.dart';

/// Hält die Erinnerungen passend zum Wesen: Jeder Gang verschiebt sie,
/// und nach dem Schlüpfen nennen sie das Wesen beim Namen.
class SyncCreatureReminder {
  SyncCreatureReminder({
    required this.plan,
    required this.scheduler,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final PlanReminder plan;
  final ReminderScheduler scheduler;
  final DateTime Function() _clock;
  String? _handled;

  /// [hungryAt]: wann der Hungerbalken leer ist, für dringliche
  /// Erinnerungen.
  Future<void> call(Creature creature, {DateTime? hungryAt}) async {
    final fedAt = creature.lastFedAt;
    final name = creature.hatched
        ? SpeciesCatalog.byId(creature.speciesId).name
        : null;
    final key = '$fedAt|$name|$hungryAt';
    if (fedAt == null || key == _handled) return;
    _handled = key;
    final now = _clock();
    final reminders = [
      for (final r in plan(fedAt, name: name, hungryAt: hungryAt))
        if (r.at.isAfter(now)) r,
    ];
    try {
      if (reminders.isEmpty) {
        await scheduler.cancel();
      } else {
        await scheduler.scheduleAll(reminders);
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
