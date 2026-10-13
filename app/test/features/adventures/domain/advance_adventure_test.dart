import 'package:flutter_test/flutter_test.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/adventures/adventures.dart';
import 'package:wandoo/features/adventures/domain/plan_week.dart';

void main() {
  const advance = AdvanceAdventure();
  final wednesday = DateTime(2026, 10, 14, 17);

  test('jede Woche drei Abenteuer, dieselbe Woche dieselben', () {
    final a = const PlanWeek()(wednesday);
    final b = const PlanWeek()(DateTime(2026, 10, 18, 22));
    expect(a.weekStart, DateTime(2026, 10, 12));
    expect(a.quests, hasLength(3));
    expect(
      [for (final q in a.quests) (q.kind, q.goal, q.environment)],
      [for (final q in b.quests) (q.kind, q.goal, q.environment)],
    );
  });

  test('ohne gespeicherte Woche wird eine geplant und gezählt', () {
    final step = advance(null, {EnvironmentType.forest: 2}, wednesday);
    expect(step.adventure.quests.first.progress, 2);
    expect(step.completed, isEmpty);
  });

  test('neue Woche, neue Abenteuer', () {
    final old = advance(null, {EnvironmentType.forest: 5}, wednesday);
    final nextWeek = wednesday.add(const Duration(days: 7));
    final step = advance(old.adventure, {}, nextWeek);
    expect(step.adventure.weekStart, DateTime(2026, 10, 19));
    expect(step.adventure.quests.first.progress, 0);
  });

  test('geschaffte Abenteuer einmal melden, alle drei: Glücks-Ei', () {
    final week = WeeklyAdventure(
      weekStart: DateTime(2026, 10, 12),
      quests: const [
        Quest(kind: QuestKind.newSegments, goal: 2),
        Quest(kind: QuestKind.discoveryWalks, goal: 1),
        Quest(kind: QuestKind.newSegments, goal: 5, progress: 5),
      ],
    );
    final step = advance(week, {EnvironmentType.city: 2}, wednesday);
    expect(step.completed, hasLength(2));
    expect(step.earnedBonus, isTrue);
    expect(step.adventure.bonusClaimed, isTrue);

    final again = advance(step.adventure, {EnvironmentType.city: 2}, wednesday);
    expect(again.completed, isEmpty);
    expect(again.earnedBonus, isFalse);
  });
}
