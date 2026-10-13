import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/creature/data/in_memory_creature_repository.dart';
import 'package:wandoo/features/world/world.dart';

void main() {
  Future<void> showAtNight(WidgetTester tester, {bool walking = false}) async {
    final repo = InMemoryCreatureRepository();
    await repo.save(const Creature(food: 30, speciesId: 'moosel'));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          creatureRepositoryProvider.overrideWithValue(repo),
          worldClockProvider.overrideWithValue(
            () => DateTime(2026, 10, 14, 22),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(body: CreatureCard(walking: walking)),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('nachts schläft das Wesen', (tester) async {
    await showAtNight(tester);
    expect(find.text('Psst, dein Wesen schläft. Gute Nacht!'), findsOneWidget);
    final figure = tester.widget<CreatureFigure>(find.byType(CreatureFigure));
    expect(figure.world?.night, isTrue);
    expect(figure.awake, isFalse);
  });

  testWidgets('beim Laufen ist es auch nachts wach', (tester) async {
    await showAtNight(tester, walking: true);
    expect(find.textContaining('läuft mit'), findsOneWidget);
    expect(find.textContaining('schläft'), findsNothing);
    final figure = tester.widget<CreatureFigure>(find.byType(CreatureFigure));
    expect(figure.awake, isTrue);
  });
}
