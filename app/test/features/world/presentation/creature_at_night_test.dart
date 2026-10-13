import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/creature/data/in_memory_creature_repository.dart';
import 'package:wandoo/features/world/world.dart';

void main() {
  testWidgets('nachts schläft das Wesen im Sternenhimmel', (tester) async {
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
        child: const MaterialApp(home: Scaffold(body: CreatureCard())),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Psst, dein Wesen schläft. Gute Nacht!'), findsOneWidget);
    expect(find.byType(WeatherLayer), findsOneWidget);
    final figure = tester.widget<CreatureFigure>(find.byType(CreatureFigure));
    expect(figure.world?.night, isTrue);
  });
}
