import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/creature/data/in_memory_creature_repository.dart';
import 'package:wandoo/features/levels/data/in_memory_progress_repository.dart';
import 'package:wandoo/features/levels/levels.dart';

void main() {
  const moosel = Creature(food: 25, speciesId: 'moosel');

  testWidgets('die Level-Nachricht verschwindet nach 3 Sekunden von selbst', (
    tester,
  ) async {
    final levels = InMemoryProgressRepository([
      Progress(lineKey: moosel.lineKey, xp: 200, news: const ['⬆️ Level 3!']),
    ]);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          creatureRepositoryProvider.overrideWithValue(
            InMemoryCreatureRepository(moosel),
          ),
          progressRepositoryProvider.overrideWithValue(levels),
        ],
        child: const MaterialApp(home: Scaffold(body: LevelUpBanner())),
      ),
    );
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('⬆️ Level 3!'), findsOneWidget);
    expect((await levels.load(moosel.lineKey)).news, isEmpty);

    await tester.pump(LevelUpBanner.shown);
    await tester.pumpAndSettle();
    expect(find.text('⬆️ Level 3!'), findsNothing);
  });
}
