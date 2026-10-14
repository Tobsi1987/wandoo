import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/reminders/reminders.dart';
import 'package:wandoo/flows/creature_reminder/sync_creature_reminder.dart';

class _FakeScheduler implements ReminderScheduler {
  final plans = <List<Reminder>>[];
  int cancelled = 0;

  @override
  Future<void> scheduleAll(List<Reminder> reminders) async =>
      plans.add(reminders);

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

  test('plant nach einem Gang genau einmal, für die nächsten Tage', () async {
    final fed = Creature(food: 5, lastFedAt: now);
    await sync(fed);
    await sync(fed);
    expect(scheduler.plans, hasLength(1));
    expect(scheduler.plans.single.first.at, DateTime(2026, 10, 14, 16));
  });

  test('nach dem Schlüpfen neu, mit Namen', () async {
    await sync(Creature(food: 5, lastFedAt: now));
    await sync(Creature(food: 30, speciesId: 'aurora', lastFedAt: now));
    expect(scheduler.plans, hasLength(2));
    expect(scheduler.plans.last.first.title, 'Aurora möchte raus');
  });

  test('ein Wesen ohne Gang fragt nicht nach Erlaubnis', () async {
    await sync(const Creature());
    expect(scheduler.plans, isEmpty);
    expect(scheduler.cancelled, 0);
  });

  test('verpasste Erinnerungen werden nicht nachgeholt', () async {
    await sync(Creature(lastFedAt: now.subtract(const Duration(days: 2))));
    expect(scheduler.plans.single.map((r) => r.at), [
      DateTime(2026, 10, 13, 16),
      DateTime(2026, 10, 14, 16),
    ]);
    await sync(Creature(lastFedAt: now.subtract(const Duration(days: 5))));
    expect(scheduler.cancelled, 1);
  });
}
