import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/bootstrap/demo/in_memory_walk_summary_repository.dart';
import 'package:wandoo/features/walk_summary/walk_summary.dart';

final _summary = WalkSummary(
  walkId: 'w1',
  finishedAt: DateTime(2026, 10, 14),
  newSegmentCount: 12,
  newStreetCount: 12,
  streetsByEnvironment: const {},
  bridgeCount: 0,
  creatureGrew: false,
  distanceMeters: 1400,
  extraLines: const [
    '🌺 3 Mohnblumen',
    '🏅 Zusammen 1 km gelaufen',
    '⬆️ Level 2! 🎁 🐚 2 Muscheln',
  ],
);

void main() {
  testWidgets('Seite für Seite: Zahlen, Unterwegs, Level, Extra nur am Ende', (
    tester,
  ) async {
    final repo = InMemoryWalkSummaryRepository();
    await repo.save(_summary);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [walkSummaryRepositoryProvider.overrideWithValue(repo)],
        child: const MaterialApp(
          home: Scaffold(body: WalkSummaryCard(lastPageExtra: Text('Extra'))),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Toller Gang!'), findsOne);
    expect(find.text('3 Mohnblumen'), findsNothing);
    expect(find.text('Extra'), findsNothing);
    await tester.tap(find.text('Weiter'));
    await tester.pumpAndSettle();
    expect(find.text('Unterwegs passiert'), findsOne);
    expect(find.text('3 Mohnblumen'), findsOne);
    expect(find.textContaining('Level'), findsNothing);
    await tester.tap(find.text('Weiter'));
    await tester.pumpAndSettle();
    expect(find.text('Level 2! 🎁 🐚 2 Muscheln'), findsOne);
    expect(find.text('Extra'), findsOne);
    await tester.tap(find.text('Fertig'));
    await tester.pumpAndSettle();
    expect(find.byType(Card), findsNothing);
  });
}
