import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/adventures/adventures.dart';
import 'package:wandoo/features/adventures/data/in_memory_adventure_repository.dart';

void main() {
  testWidgets('zeigt drei Abenteuer, Fortschritt und das Glücks-Ei', (
    tester,
  ) async {
    final repo = InMemoryAdventureRepository();
    await repo.save(
      WeeklyAdventure(
        weekStart: DateTime(2026, 10, 12),
        quests: const [
          Quest(kind: QuestKind.newSegments, goal: 25, progress: 10),
          Quest(kind: QuestKind.discoveryWalks, goal: 3, progress: 3),
        ],
      ),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          adventureRepositoryProvider.overrideWithValue(repo),
          adventureClockProvider.overrideWithValue(
            () => DateTime(2026, 10, 14, 9),
          ),
        ],
        child: const MaterialApp(home: AdventureScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Entdecke 25 neue Wegstücke'), findsOneWidget);
    expect(find.textContaining('10 von 25'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    expect(find.text('Noch 5 Tage, dann gibt es neue Abenteuer.'), findsOne);
    expect(find.text('Alle drei schaffen'), findsOneWidget);
  });

  testWidgets('alte Woche gespeichert: es gibt frische Abenteuer', (
    tester,
  ) async {
    final repo = InMemoryAdventureRepository();
    await repo.save(
      WeeklyAdventure(
        weekStart: DateTime(2026, 10, 5),
        quests: const [Quest(kind: QuestKind.newSegments, goal: 3)],
      ),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          adventureRepositoryProvider.overrideWithValue(repo),
          adventureClockProvider.overrideWithValue(
            () => DateTime(2026, 10, 14, 9),
          ),
        ],
        child: const MaterialApp(home: AdventureScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.flag_outlined), findsNWidgets(3));
  });
}
