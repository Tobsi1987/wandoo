import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/reminders/domain/plan_reminder.dart';
import 'package:wandoo/features/reminders/domain/reminder_scheduler.dart';

/// Wird in `bootstrap/providers.dart` mit einer Umsetzung belegt.
final reminderSchedulerProvider = Provider<ReminderScheduler>(
  (ref) => throw UnimplementedError('In bootstrap/providers.dart setzen.'),
);

final planReminderProvider = Provider<PlanReminder>(
  (ref) => const PlanReminder(),
);
