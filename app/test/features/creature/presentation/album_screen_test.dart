import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/creature/data/in_memory_creature_repository.dart';

void main() {
  testWidgets('nur erreichte Stufen in Farbe, Unentdecktes ohne Namen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 8000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final repo = InMemoryCreatureRepository();
    await repo.save(
      const Creature(
        food: 30,
        speciesId: 'pfuetzling',
        seenSpecies: {'moosel'},
      ),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          creatureRepositoryProvider.overrideWithValue(repo),
          reachedStagesProvider.overrideWithValue({'moosel': 3}),
        ],
        child: const MaterialApp(home: AlbumScreen()),
      ),
    );
    await tester.pumpAndSettle();
    final total = SpeciesCatalog.all.length;
    expect(find.text('2 von $total Tieren entdeckt'), findsOneWidget);
    expect(
      find.textContaining('Pfützling', findRichText: true),
      findsOneWidget,
    );
    expect(
      find.textContaining('???', findRichText: true),
      findsNWidgets(total - 2),
    );
    final silhouettes = tester
        .widgetList<CreatureFigure>(find.byType(CreatureFigure))
        .where((f) => f.silhouette);
    // Moosel hat alle drei Stufen, Pfützling nur die erste.
    expect(silhouettes, hasLength((total - 2) * 3 + 2));
  });
}
