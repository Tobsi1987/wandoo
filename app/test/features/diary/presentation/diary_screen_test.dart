import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/creature/data/in_memory_creature_repository.dart';
import 'package:wandoo/features/diary/data/in_memory_diary_repository.dart';
import 'package:wandoo/features/diary/diary.dart';
import 'package:wandoo/features/discovery_map/discovery_map.dart';

void main() {
  Future<InMemoryDiaryRepository> pump(WidgetTester tester) async {
    final creatures = InMemoryCreatureRepository();
    await creatures.save(const Creature(food: 30, speciesId: 'aurora'));
    final diaries = InMemoryDiaryRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          creatureRepositoryProvider.overrideWithValue(creatures),
          diaryRepositoryProvider.overrideWithValue(diaries),
          showBaseMapProvider.overrideWithValue(false),
        ],
        child: const MaterialApp(home: DiaryScreen()),
      ),
    );
    await tester.pumpAndSettle();
    return diaries;
  }

  testWidgets('leeres Tagebuch lädt zum Losgehen ein', (tester) async {
    await pump(tester);
    expect(find.text('Tagebuch von Aurora'), findsOneWidget);
    expect(find.textContaining('Noch keine Einträge'), findsOneWidget);
  });

  testWidgets('zeigt Zahlen, Karte und Erinnerungen, neueste oben', (
    tester,
  ) async {
    final diaries = await pump(tester);
    await diaries.add(
      DiaryWalk(
        walkId: 'w1',
        creatureKey: 'erstes',
        finishedAt: DateTime(2026, 10, 13, 15),
        meters: 1250,
        path: const [GeoPoint(52, 7), GeoPoint(52.01, 7.01)],
      ),
      [
        Memory(
          creatureKey: 'erstes',
          at: DateTime(2026, 10, 13, 15),
          emoji: '🥚',
          title: 'Erster Ausflug mit dem Ei',
          place: const GeoPoint(52, 7),
        ),
        Memory(
          creatureKey: 'erstes',
          at: DateTime(2026, 10, 13, 16),
          emoji: '🐣',
          title: 'Hier bist du geschlüpft',
          place: const GeoPoint(52.01, 7.01),
        ),
      ],
    );
    await tester.pumpAndSettle();
    expect(find.text('1 Gang'), findsOneWidget);
    expect(find.text('1,3 km'), findsOneWidget);
    expect(find.text('seit 13. Okt. 2026'), findsOneWidget);
    expect(find.byType(DiaryMap), findsOneWidget);
    final hatch = tester.getTopLeft(find.text('Hier bist du geschlüpft'));
    final egg = tester.getTopLeft(find.text('Erster Ausflug mit dem Ei'));
    expect(hatch.dy, lessThan(egg.dy));
  });
}
