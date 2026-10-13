import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/reminders/reminders.dart';

void main() {
  const plan = PlanReminder();

  test('ohne Gang keine Erinnerung', () {
    expect(plan(null), isEmpty);
  });

  test('an den drei Tagen danach je eine, nachmittags um 16 Uhr', () {
    final at = plan(DateTime(2026, 10, 13, 21, 30)).map((r) => r.at);
    expect(at, [
      DateTime(2026, 10, 14, 16),
      DateTime(2026, 10, 15, 16),
      DateTime(2026, 10, 16, 16),
    ]);
  });

  test('nie abends und nie zweimal am selben Tag', () {
    final reminders = plan(DateTime(2026, 10, 31, 7), name: 'Aurora');
    final days = {
      for (final r in reminders) DateTime(r.at.year, r.at.month, r.at.day),
    };
    expect(days, hasLength(reminders.length));
    expect(reminders.every((r) => r.at.hour < 18), isTrue);
    expect(reminders.first.at, DateTime(2026, 11, 1, 16));
  });

  test('nennt das Wesen beim Namen, jeden Tag anders', () {
    final reminders = plan(DateTime(2026, 10, 13), name: 'Aurora');
    expect(reminders.first.title, 'Aurora möchte raus');
    expect(reminders.map((r) => r.title).toSet(), hasLength(3));
    expect(reminders.every((r) => r.body.contains('Aurora')), isTrue);
  });

  test('ein Ei bekommt eigene Texte', () {
    expect(plan(DateTime(2026, 10, 13)).first.title, 'Dein Ei ist ganz warm');
  });
}
