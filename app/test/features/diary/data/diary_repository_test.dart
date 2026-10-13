import 'package:flutter_test/flutter_test.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/diary/data/drift_diary_repository.dart';
import 'package:wandoo/features/diary/data/in_memory_diary_repository.dart';
import 'package:wandoo/features/diary/diary.dart';

import '../../../support/test_database.dart';

void main() {
  final repos = <String, DiaryRepository Function()>{
    'Datenbank': () => DriftDiaryRepository(testDatabase()),
    'Speicher': InMemoryDiaryRepository.new,
  };
  DiaryWalk walk(String id, String key, int day) => DiaryWalk(
    walkId: id,
    creatureKey: key,
    finishedAt: DateTime(2026, 10, day),
    meters: 1000 * day,
    path: const [GeoPoint(52.123456, 7.5), GeoPoint(52.2, 7.6)],
  );
  for (final MapEntry(key: name, value: make) in repos.entries) {
    test('$name: Tagebuch je Wesen, älteste Einträge zuerst', () async {
      final repo = make();
      final updates = repo.watch('a').map((d) => d.walks.length);
      expect(await updates.first, 0);
      await repo.add(walk('w2', 'a', 14), [
        Memory(
          creatureKey: 'a',
          at: DateTime(2026, 10, 14),
          emoji: '🐣',
          title: 'Hier bist du geschlüpft',
          place: const GeoPoint(52.2, 7.6),
        ),
      ]);
      await repo.add(walk('w1', 'a', 13), const []);
      await repo.add(walk('x', 'b', 15), const []);

      final diary = await repo.load('a');
      expect(diary.walks.map((w) => w.walkId), ['w1', 'w2']);
      expect(diary.meters, 27000);
      expect(diary.since, DateTime(2026, 10, 13));
      expect(diary.walks.first.path.first.latitude, closeTo(52.12346, 1e-5));
      expect(diary.memories.single.place, isNotNull);
      expect((await repo.load('b')).walks, hasLength(1));
      expect(await repo.watch('a').map((d) => d.walks.length).first, 2);
    });
  }
}
