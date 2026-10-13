import 'package:flutter_test/flutter_test.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/diary/data/in_memory_diary_repository.dart';
import 'package:wandoo/features/petting/data/in_memory_friendship_repository.dart';
import 'package:wandoo/features/walk_summary/walk_summary.dart';
import 'package:wandoo/flows/process_walk/extras/diary_extra.dart';
import 'package:wandoo/flows/process_walk/extras/friendship_extra.dart';
import 'package:wandoo/flows/process_walk/walk_extra.dart';

WalkOutcome _walk(String id, Creature before, Creature after) {
  final at = DateTime(2026, 10, 13, 15);
  return WalkOutcome(
    track: Track(
      id: id,
      points: [
        TrackPoint(const GeoPoint(52, 7), at),
        TrackPoint(const GeoPoint(52.01, 7), at),
      ],
    ),
    summary: WalkSummary(
      walkId: id,
      finishedAt: at,
      newSegmentCount: 0,
      newStreetCount: 0,
      streetsByEnvironment: const {},
      bridgeCount: 0,
      creatureGrew: false,
    ),
    newSegmentsByEnvironment: const {},
    before: before,
    after: after,
  );
}

void main() {
  const egg = Creature(food: 10);
  const hatched = Creature(food: 20, speciesId: 'aurora', walkedMeters: 1100);

  test('Tagebuch: Ei-Ausflug, Schlüpfen, erster Kilometer', () async {
    final diaries = InMemoryDiaryRepository();
    final extra = DiaryExtra(diaries);
    final lines = await extra.onWalk(_walk('w1', egg, hatched));
    final diary = await diaries.load(hatched.lineKey);
    expect(diary.walks.single.meters, 1100);
    expect(diary.memories.map((m) => m.emoji), ['🥚', '🐣', '🏅']);
    expect(lines, ['🏅 Zusammen 1 km gelaufen']);

    final later = hatched.copyWith(walkedMeters: 1500);
    expect(await extra.onWalk(_walk('w2', hatched, later)), isEmpty);
    expect((await diaries.load(hatched.lineKey)).memories, hasLength(3));
  });

  test('Freundschaft: Gänge mit Ei zählen nicht, sonst drei Punkte', () async {
    final friendships = InMemoryFriendshipRepository();
    final extra = FriendshipExtra(friendships);
    expect(await extra.onWalk(_walk('w1', egg, egg)), isEmpty);
    expect((await friendships.load(egg.lineKey)).points, 0);
    await extra.onWalk(_walk('w2', egg, hatched));
    await extra.onWalk(_walk('w3', hatched, hatched));
    await extra.onWalk(_walk('w4', hatched, hatched));
    final lines = await extra.onWalk(_walk('w5', hatched, hatched));
    expect((await friendships.load(hatched.lineKey)).points, 12);
    expect(lines, ['💗 Aurora hat dich noch lieber: 1 Herz']);
  });
}
