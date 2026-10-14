import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/creature/data/in_memory_creature_repository.dart';
import 'package:wandoo/features/creature/data/in_memory_marks_setting_repository.dart';

void main() {
  Future<InMemoryMarksSettingRepository> pump(
    WidgetTester tester,
    Creature creature,
  ) async {
    final setting = InMemoryMarksSettingRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          creatureRepositoryProvider.overrideWithValue(
            InMemoryCreatureRepository(creature),
          ),
          marksSettingRepositoryProvider.overrideWithValue(setting),
        ],
        child: const MaterialApp(home: Scaffold(body: WorldMarksSwitch())),
      ),
    );
    await tester.pumpAndSettle();
    return setting;
  }

  testWidgets('schaltet die Spuren aus und wieder an', (tester) async {
    final setting = await pump(
      tester,
      Creature(
        food: GrowthStage.adult.foodNeeded,
        speciesId: 'funkel',
        traitPoints: const {Trait.moss: 50},
      ),
    );
    expect(find.text('Moos aus dem Wald'), findsOneWidget);
    await tester.tap(find.byKey(const Key('world-marks')));
    await tester.pumpAndSettle();
    expect(setting.current, isFalse);
    await tester.tap(find.byKey(const Key('world-marks')));
    await tester.pumpAndSettle();
    expect(setting.current, isTrue);
  });

  testWidgets('ohne Spur kein Schalter', (tester) async {
    await pump(tester, const Creature());
    expect(find.byKey(const Key('world-marks')), findsNothing);
  });
}
