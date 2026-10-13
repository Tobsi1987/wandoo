import 'package:flutter_test/flutter_test.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/adventures/adventures.dart';
import 'package:wandoo/features/adventures/data/drift_adventure_repository.dart';

import '../../../support/test_database.dart';

void main() {
  test('noch keine Abenteuer gespeichert', () async {
    final db = testDatabase();
    addTearDown(db.close);
    expect(await DriftAdventureRepository(db).load(), isNull);
  });

  test('speichert Woche, Fortschritt und Glücks-Ei', () async {
    final db = testDatabase();
    addTearDown(db.close);
    final repo = DriftAdventureRepository(db);
    final week = WeeklyAdventure(
      weekStart: DateTime(2026, 10, 12),
      quests: const [
        Quest(
          kind: QuestKind.newInEnvironment,
          environment: EnvironmentType.water,
          goal: 8,
          progress: 3,
          rewardEnvironment: EnvironmentType.water,
          rewardCount: 3,
        ),
      ],
      bonusClaimed: true,
    );
    await repo.save(week);
    final loaded = (await repo.load())!;
    expect(loaded.weekStart, DateTime(2026, 10, 12));
    expect(loaded.bonusClaimed, isTrue);
    final q = loaded.quests.single;
    expect(q.kind, QuestKind.newInEnvironment);
    expect(q.environment, EnvironmentType.water);
    expect((q.progress, q.goal, q.rewardCount), (3, 8, 3));
    expect(q.rewardEnvironment, EnvironmentType.water);
  });
}
