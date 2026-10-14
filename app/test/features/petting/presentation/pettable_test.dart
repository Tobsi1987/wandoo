import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/creature/data/in_memory_creature_repository.dart';
import 'package:wandoo/features/petting/data/in_memory_friendship_repository.dart';
import 'package:wandoo/features/petting/petting.dart';
import 'package:wandoo/features/sounds/data/in_memory_sound_settings_repository.dart';
import 'package:wandoo/features/sounds/data/silent_sound_player.dart';
import 'package:wandoo/features/sounds/sounds.dart';

final _sounds = SilentSoundPlayer();

Future<InMemoryFriendshipRepository> _pump(
  WidgetTester tester,
  Creature creature,
) async {
  final creatures = InMemoryCreatureRepository();
  await creatures.save(creature);
  final friendships = InMemoryFriendshipRepository();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        creatureRepositoryProvider.overrideWithValue(creatures),
        friendshipRepositoryProvider.overrideWithValue(friendships),
        soundPlayerProvider.overrideWithValue(_sounds),
        soundSettingsRepositoryProvider.overrideWithValue(
          InMemorySoundSettingsRepository(),
        ),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              Pettable(child: SizedBox.square(dimension: 120)),
              HeartsBar(),
            ],
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return friendships;
}

void main() {
  testWidgets('Antippen streichelt, das erste Herz füllt sich', (tester) async {
    const creature = Creature(food: 30, speciesId: 'aurora');
    final friendships = await _pump(tester, creature);
    expect(find.bySemanticsLabel('Freundschaft: 0 von 5 Herzen'), findsOne);

    for (var i = 0; i < 3; i++) {
      await tester.tap(find.bySemanticsLabel('Wesen streicheln'));
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.byType(FloatingHearts), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byType(FloatingHearts), findsNothing);
    expect((await friendships.load(creature.lineKey)).points, 3);
    // Aurora hat eine tiefe Stimme.
    expect(_sounds.played.last, (Cue.happy, Voice.low));
  });

  testWidgets('ein Ei lässt sich noch nicht streicheln', (tester) async {
    final friendships = await _pump(tester, const Creature());
    expect(find.bySemanticsLabel('Wesen streicheln'), findsNothing);
    await tester.tap(find.byType(Pettable));
    await tester.pumpAndSettle();
    expect((await friendships.load('erstes')).points, 0);
    expect(find.byType(HeartsBar), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('Freundschaft')), findsNothing);
  });
}
