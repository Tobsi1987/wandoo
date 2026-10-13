import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/reminders/reminders.dart';

void main() {
  const plan = PlanReminder();

  test('ohne Fütterung keine Erinnerung', () {
    expect(plan(null), isNull);
  });

  test('erinnert drei Tage nach der letzten Fütterung', () {
    final at = plan(DateTime(2026, 10, 13, 14, 30))!.at;
    expect(at, DateTime(2026, 10, 16, 14, 30));
  });

  test('schiebt frühe Zeiten auf 10 Uhr desselben Tages', () {
    final at = plan(DateTime(2026, 10, 13, 6, 15))!.at;
    expect(at, DateTime(2026, 10, 16, 10));
  });

  test('schiebt Abendzeiten auf den nächsten Morgen', () {
    final at = plan(DateTime(2026, 10, 13, 21))!.at;
    expect(at, DateTime(2026, 10, 17, 10));
  });
}
