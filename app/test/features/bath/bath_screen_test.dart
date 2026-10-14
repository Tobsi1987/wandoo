import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/bath/bath.dart';
import 'package:wandoo/features/bath/data/in_memory_mud_repository.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/creature/data/in_memory_creature_repository.dart';
import 'package:wandoo/features/sounds/data/in_memory_sound_settings_repository.dart';
import 'package:wandoo/features/sounds/sounds.dart';

class _Silent implements SoundPlayer {
  @override
  Future<void> play(Cue cue, Voice voice) async {}
}

void main() {
  setUp(() => CreatureFigure.models = false);

  testWidgets('Wischen wäscht den Matsch ab', (tester) async {
    final creature = Creature(
      food: GrowthStage.adult.foodNeeded,
      speciesId: 'moosel',
    );
    final mud = InMemoryMudRepository({creature.lineKey: 2});
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          creatureRepositoryProvider.overrideWithValue(
            InMemoryCreatureRepository(creature),
          ),
          mudRepositoryProvider.overrideWithValue(mud),
          soundPlayerProvider.overrideWithValue(_Silent()),
          soundSettingsRepositoryProvider.overrideWithValue(
            InMemorySoundSettingsRepository(),
          ),
        ],
        child: const MaterialApp(home: BathScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Wisch mit dem Finger'), findsOneWidget);
    for (var i = 0; i < 12; i++) {
      await tester.drag(find.byKey(const Key('foam')), const Offset(200, 0));
      await tester.pump();
    }
    await tester.pumpAndSettle();
    expect(find.textContaining('blitzsauber'), findsOneWidget);
    expect(await mud.load(creature.lineKey), 0);
  });
}
