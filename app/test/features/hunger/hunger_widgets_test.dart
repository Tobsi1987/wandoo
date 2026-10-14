import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/creature/data/in_memory_creature_repository.dart';
import 'package:wandoo/features/hunger/data/in_memory_belly_repository.dart';
import 'package:wandoo/features/hunger/hunger.dart';

final _now = DateTime(2026, 10, 14, 12);

Future<InMemoryBellyRepository> _pump(WidgetTester tester, Belly? belly) async {
  final bellies = InMemoryBellyRepository([?belly]);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        creatureRepositoryProvider.overrideWithValue(
          InMemoryCreatureRepository(
            const Creature(food: 30, speciesId: 'moosel'),
          ),
        ),
        bellyRepositoryProvider.overrideWithValue(bellies),
        hungerClockProvider.overrideWithValue(() => _now),
      ],
      child: const MaterialApp(
        home: Scaffold(body: Column(children: [HungerBar(), FarewellLetter()])),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return bellies;
}

void main() {
  testWidgets('frisch geschlüpft ist der Bauch voll', (tester) async {
    await _pump(tester, null);
    expect(find.bySemanticsLabel('Bauch zu 100 Prozent voll'), findsOne);
    expect(find.textContaining('Hunger!'), findsNothing);
  });

  testWidgets('leerer Bauch sagt, was zu tun ist', (tester) async {
    await _pump(tester, Belly(lineKey: 'erstes', meters: 0, at: _now));
    expect(find.text('Moosel hat Hunger! Geht zusammen raus.'), findsOne);
  });

  testWidgets('der Abschiedsbrief verschwindet nach dem Lesen', (tester) async {
    final bellies = await _pump(tester, null);
    await bellies.leaveLetter(Farewell(speciesId: 'moosel', at: _now));
    await tester.pumpAndSettle();
    expect(find.text('💌 Ein Brief von Moosel'), findsOne);
    await tester.tap(find.text('Zum neuen Ei'));
    await tester.pumpAndSettle();
    expect(find.text('💌 Ein Brief von Moosel'), findsNothing);
  });
}
