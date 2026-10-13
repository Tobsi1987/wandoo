import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/creature/data/in_memory_creature_repository.dart';

void main() {
  testWidgets('entdeckte Arten mit Namen, die anderen als Umriss', (
    tester,
  ) async {
    final repo = InMemoryCreatureRepository();
    await repo.save(
      const Creature(food: 30, speciesId: 'axolotl', seenSpecies: {'moosbaer'}),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [creatureRepositoryProvider.overrideWithValue(repo)],
        child: const MaterialApp(home: AlbumScreen()),
      ),
    );
    await tester.pumpAndSettle();
    final total = SpeciesCatalog.all.length;
    expect(find.text('2 von $total Tieren entdeckt'), findsOneWidget);
    expect(find.text('Wasser-Axolotl'), findsOneWidget);
    expect(find.text('???'), findsNWidgets(total - 2));
    final silhouettes = tester
        .widgetList<CreatureFigure>(find.byType(CreatureFigure))
        .where((f) => f.silhouette);
    expect(silhouettes, hasLength(total - 2));
  });
}
