import 'package:flutter_test/flutter_test.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/adventures/adventures.dart';
import 'package:wandoo/features/adventures/data/in_memory_adventure_repository.dart';
import 'package:wandoo/features/creature/data/in_memory_creature_repository.dart';
import 'package:wandoo/features/treasure/data/in_memory_treasure_repository.dart';
import 'package:wandoo/features/treasure/treasure.dart';
import 'package:wandoo/features/walk_summary/walk_summary.dart';
import 'package:wandoo/flows/process_walk/extras/adventure_extra.dart';
import 'package:wandoo/flows/process_walk/walk_extra.dart';

void main() {
  test('Belohnungen in die Kiste, alle drei geben ein Glücks-Ei', () async {
    final adventures = InMemoryAdventureRepository();
    final chests = InMemoryTreasureRepository();
    final creatures = InMemoryCreatureRepository();
    final finished = DateTime(2026, 10, 14, 17);
    await adventures.save(
      WeeklyAdventure(
        weekStart: DateTime(2026, 10, 12),
        quests: const [
          Quest(
            kind: QuestKind.newInEnvironment,
            environment: EnvironmentType.forest,
            goal: 2,
            rewardEnvironment: EnvironmentType.forest,
            rewardCount: 3,
          ),
          Quest(kind: QuestKind.newSegments, goal: 2),
        ],
      ),
    );
    final extra = AdventureExtra(
      adventures: adventures,
      chests: chests,
      creatures: creatures,
    );
    final lines = await extra.onWalk(
      WalkOutcome(
        track: const Track(id: 'gang', points: []),
        summary: WalkSummary(
          walkId: 'gang',
          finishedAt: finished,
          newSegmentCount: 2,
          newStreetCount: 1,
          streetsByEnvironment: const {EnvironmentType.forest: 1},
          bridgeCount: 0,
          creatureGrew: false,
        ),
        newSegmentsByEnvironment: const {EnvironmentType.forest: 2},
      ),
    );
    final chest = await chests.load();
    expect(chest.count(Find.acorn), 3);
    expect(chest.count(Find.starShard), 1);
    expect((await creatures.load()).luckyEgg, isTrue);
    expect(lines, hasLength(3));
    expect(lines.last, contains('Glücks-Ei'));
  });
}
