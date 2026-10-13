import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/reminders/reminders.dart';
import 'package:wandoo/flows/creature_reminder/sync_creature_reminder.dart';

final syncCreatureReminderProvider = Provider<SyncCreatureReminder>(
  (ref) => SyncCreatureReminder(
    plan: ref.watch(planReminderProvider),
    scheduler: ref.watch(reminderSchedulerProvider),
  ),
);
