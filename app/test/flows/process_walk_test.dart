import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/core/map_data/map_data_source.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/creature/data/in_memory_creature_repository.dart';
import 'package:wandoo/features/discovery/data/in_memory_known_segments_repository.dart';
import 'package:wandoo/features/discovery/discovery.dart';
import 'package:wandoo/features/environment/environment.dart';
import 'package:wandoo/features/treasure/data/in_memory_treasure_repository.dart';
import 'package:wandoo/features/treasure/treasure.dart';
import 'package:wandoo/flows/process_walk/extras/treasure_extra.dart';
import 'package:wandoo/flows/process_walk/process_walk.dart';

import '../support/fake_walk_summary_repository.dart';

class _ForestPath implements MapDataSource {
  @override
  Future<List<RoadSegment>> segmentsNear(List<GeoPoint> points) async => [
    const RoadSegment(
      id: 'waldweg',
      start: GeoPoint(50, 8),
      end: GeoPoint(50, 8.002),
      areaTags: {'landuse': 'forest'},
    ),
  ];
}

void main() {
  final start = DateTime.utc(2026, 10, 12, 8);
  final track = Track(
    id: 'gang-1',
    points: [
      for (var i = 0; i <= 20; i++)
        TrackPoint(
          GeoPoint(50.00002, 8 + 0.0001 * i),
          start.add(Duration(seconds: 5 * i)),
        ),
    ],
  );

  test(
    'ein neuer Waldweg füttert das Wesen, derselbe Weg nicht nochmal',
    () async {
      final process = ProcessWalk(
        mapData: _ForestPath(),
        discover: DiscoverSegments(
          repository: InMemoryKnownSegmentsRepository(),
        ),
        classify: const ClassifySegments(),
        creatures: InMemoryCreatureRepository(),
        summaries: FakeWalkSummaryRepository(),
      );
      final first = await process(track);
      expect(first.newSegmentCount, 1);
      expect(first.creature.traitPoints, {Trait.moss: 1});

      final second = await process(track);
      expect(second.newSegmentCount, 0);
      expect(second.summary.knownSegmentCount, 1);
      expect(second.creature.food, 1);
      expect(second.creature.lastFedAt, isNotNull);
    },
  );

  test('Fundstücke landen in der Kiste und in der Zusammenfassung', () async {
    final chests = InMemoryTreasureRepository();
    final process = ProcessWalk(
      mapData: _ForestPath(),
      discover: DiscoverSegments(repository: InMemoryKnownSegmentsRepository()),
      classify: const ClassifySegments(),
      creatures: InMemoryCreatureRepository(),
      summaries: FakeWalkSummaryRepository(),
      extras: [
        TreasureExtra(
          chests,
          drop: const DropFinds(chance: 1),
          random: Random(2),
        ),
      ],
    );
    final result = await process(track);
    final chest = await chests.load();
    expect(chest.count(Find.acorn) + chest.count(Find.starShard), 1);
    expect(result.summary.extraLines.single, startsWith('Gefunden: '));
  });
}
