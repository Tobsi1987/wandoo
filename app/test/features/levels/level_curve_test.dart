import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/levels/data/drift_progress_repository.dart';
import 'package:wandoo/features/levels/levels.dart';

import '../../support/test_database.dart';

void main() {
  test('erste Level schnell, Stufe 2 ab Level 10, Stufe 3 ab 25', () {
    expect(LevelCurve.levelFor(0), 1);
    expect(LevelCurve.levelFor(LevelCurve.need(1)), 2);
    // Ein Kilometer mit ein paar neuen Straßen reicht anfangs für ein Level.
    expect(Xp.forWalk(meters: 1000, newSegments: 4), greaterThan(110));
    expect(LevelCurve.xpFor(10), 900);
    expect(LevelCurve.stageFor(9), 1);
    expect(LevelCurve.stageFor(10), 2);
    expect(LevelCurve.stageFor(25), 3);
    expect(LevelCurve.levelFor(999999), LevelCurve.maxLevel);
    expect(LevelCurve.towardNext(999999), 1);
    expect(
      LevelCurve.towardNext(LevelCurve.xpFor(4) + 41),
      closeTo(0.43, 0.01),
    );
  });

  test('Datenbank merkt sich Erfahrung und Nachrichten', () async {
    final repo = DriftProgressRepository(testDatabase());
    expect((await repo.load('erstes')).xp, 0);
    await repo.save(const Progress(lineKey: 'erstes', xp: 120, news: ['a']));
    await repo.save(const Progress(lineKey: 'zweites', xp: 5));
    final loaded = await repo.load('erstes');
    expect(loaded.xp, 120);
    expect(loaded.level, 2);
    expect(loaded.news, ['a']);
    expect((await repo.load('zweites')).xp, 5);
  });
}
