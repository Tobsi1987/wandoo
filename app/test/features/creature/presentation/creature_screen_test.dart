import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/creature/data/in_memory_creature_repository.dart';

void main() {
  testWidgets('zeigt am Anfang ein Ei', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          creatureRepositoryProvider.overrideWithValue(
            InMemoryCreatureRepository(),
          ),
        ],
        child: const MaterialApp(home: CreatureScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Ei'), findsOneWidget);
  });
}
