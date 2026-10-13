import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/creature/data/in_memory_creature_repository.dart';

void main() {
  testWidgets('zeigt das Ei und danach das gefütterte Wesen', (tester) async {
    final repo = InMemoryCreatureRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [creatureRepositoryProvider.overrideWithValue(repo)],
        child: const MaterialApp(home: Scaffold(body: CreatureCard())),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Ei'), findsOneWidget);

    await repo.save(
      const FeedCreature()(const Creature(), {
        EnvironmentType.forest: 25,
      }, DateTime(2026, 10, 13)),
    );
    await tester.pumpAndSettle();
    expect(find.text('Jungtier'), findsOneWidget);
    expect(find.text('Moos 25'), findsOneWidget);
  });
}
