import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/reminders/reminders.dart';
import 'package:wandoo/flows/creature_reminder/sync_creature_reminder.dart';

class _FakeScheduler implements ReminderScheduler {
  final scheduled = <Reminder>[];
  int cancelled = 0;

  @override
  Future<void> schedule(Reminder reminder) async => scheduled.add(reminder);

  @override
  Future<void> cancel() async => cancelled++;
}

void main() {
  late _FakeScheduler scheduler;
  late SyncCreatureReminder sync;
  final now = DateTime(2026, 10, 13, 12);

  setUp(() {
    scheduler = _FakeScheduler();
    sync = SyncCreatureReminder(
      plan: const PlanReminder(),
      scheduler: scheduler,
      clock: () => now,
    );
  });

  test('plant nach einer Fütterung genau einmal', () async {
    final fed = Creature(food: 5, lastFedAt: now);
    await sync(fed);
    await sync(fed);
    expect(scheduler.scheduled.map((r) => r.at), [DateTime(2026, 10, 16, 12)]);
  });

  test('ein nie gefüttertes Wesen fragt nicht nach Erlaubnis', () async {
    await sync(const Creature());
    expect(scheduler.scheduled, isEmpty);
    expect(scheduler.cancelled, 0);
  });

  test('verpasste Erinnerung wird nicht nachgeholt', () async {
    await sync(Creature(lastFedAt: now.subtract(const Duration(days: 5))));
    expect(scheduler.scheduled, isEmpty);
    expect(scheduler.cancelled, 1);
  });
}
