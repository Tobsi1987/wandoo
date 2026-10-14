import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/bootstrap/demo/in_memory_walk_summary_repository.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/creature/data/in_memory_creature_repository.dart';
import 'package:wandoo/features/sounds/data/in_memory_sound_settings_repository.dart';
import 'package:wandoo/features/sounds/data/silent_sound_player.dart';
import 'package:wandoo/features/sounds/sounds.dart';
import 'package:wandoo/features/star_catch/data/in_memory_star_catch_repository.dart';
import 'package:wandoo/features/star_catch/domain/star_rain.dart';
import 'package:wandoo/features/star_catch/star_catch.dart';
import 'package:wandoo/features/treasure/data/in_memory_treasure_repository.dart';
import 'package:wandoo/features/treasure/treasure.dart';
import 'package:wandoo/features/walk_summary/walk_summary.dart';

/// Läuft immer zum tiefsten Stern: so fängt man fast alle.
double _chase(StarRain rain) {
  if (rain.stars.isEmpty) return 0.5;
  final lowest = rain.stars.reduce((a, b) => a.y > b.y ? a : b);
  return lowest.x;
}

void main() {
  test('wer den Sternen nachläuft, fängt viele; wer steht, wenige', () {
    final chaser = StarRain(random: Random(1));
    final sitter = StarRain(random: Random(1));
    while (!chaser.over) {
      chaser.step(1 / 30, _chase(chaser));
    }
    while (!sitter.over) {
      sitter.step(1 / 30, 0.05);
    }
    expect(chaser.caught, greaterThanOrEqualTo(14));
    expect(chaser.caught + chaser.missed, sitter.caught + sitter.missed);
    expect(sitter.caught, lessThan(6));
    expect(shardsFor(chaser.caught), 2);
    expect(shardsFor(sitter.caught), 0);
    expect(shardsFor(6), 1);
  });

  test('Sternsplitter gibt es nur einmal je Gang', () async {
    final games = InMemoryStarCatchRepository();
    final chests = InMemoryTreasureRepository();
    final finish = FinishStarCatch(games, chests);
    expect(await finish('walk-1', 20), 2);
    expect(await finish('walk-1', 20), 0);
    expect((await chests.load()).count(Find.starShard), 2);
  });

  testWidgets('Knopf nach dem Gang, Spiel bis zum Ende, dann weg', (
    tester,
  ) async {
    CreatureFigure.animate = false;
    final creatures = InMemoryCreatureRepository();
    await creatures.save(const Creature(food: 30, speciesId: 'funkel'));
    final summaries = InMemoryWalkSummaryRepository();
    await summaries.save(
      WalkSummary(
        walkId: 'walk-1',
        finishedAt: DateTime(2026, 10, 14),
        newSegmentCount: 3,
        newStreetCount: 1,
        streetsByEnvironment: const {},
        bridgeCount: 0,
        creatureGrew: false,
      ),
    );
    final chests = InMemoryTreasureRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          creatureRepositoryProvider.overrideWithValue(creatures),
          walkSummaryRepositoryProvider.overrideWithValue(summaries),
          treasureRepositoryProvider.overrideWithValue(chests),
          starCatchRepositoryProvider.overrideWithValue(
            InMemoryStarCatchRepository(),
          ),
          soundPlayerProvider.overrideWithValue(SilentSoundPlayer()),
          soundSettingsRepositoryProvider.overrideWithValue(
            InMemorySoundSettingsRepository(),
          ),
        ],
        child: MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Column(
                children: [
                  const StarCatchButton(),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => StarCatchScreen(random: Random(2)),
                      ),
                    ),
                    child: const Text('los'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('🌠 Sternschnuppen fangen'), findsOne);
    await tester.tap(find.text('los'));
    await tester.pump();
    for (var i = 0; i < 26 * 20; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    await tester.pumpAndSettle();
    expect(find.textContaining('gefangen!'), findsOne);
    await tester.tap(find.text('Fertig'));
    await tester.pumpAndSettle();
    expect(find.text('🌠 Sternschnuppen fangen'), findsNothing);
    CreatureFigure.animate = true;
  });
}
