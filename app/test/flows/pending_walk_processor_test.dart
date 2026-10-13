import 'package:flutter_test/flutter_test.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/core/map_data/map_data_source.dart';
import 'package:wandoo/features/creature/data/in_memory_creature_repository.dart';
import 'package:wandoo/features/discovery/data/in_memory_known_segments_repository.dart';
import 'package:wandoo/features/discovery/discovery.dart';
import 'package:wandoo/features/environment/environment.dart';
import 'package:wandoo/features/tracking/data/drift_recorded_walk_repository.dart';
import 'package:wandoo/flows/process_walk/pending_walk_processor.dart';
import 'package:wandoo/flows/process_walk/process_walk.dart';

import '../support/fake_location_source.dart';
import '../support/fake_walk_summary_repository.dart';
import '../support/test_database.dart';

class _FlakyMap implements MapDataSource {
  bool offline = true;

  @override
  Future<List<RoadSegment>> segmentsNear(List<GeoPoint> points) async {
    if (offline) throw Exception('offline');
    return [
      RoadSegment(
        id: 'weg',
        start: eastOf(0, 0).position,
        end: eastOf(100, 0).position,
        areaTags: const {'landuse': 'forest'},
      ),
    ];
  }
}

void main() {
  test('offline bleibt der Gang offen und wird später verarbeitet', () async {
    final db = testDatabase();
    addTearDown(db.close);
    final walks = DriftRecordedWalkRepository(db);
    final map = _FlakyMap();
    final processor = PendingWalkProcessor(
      walks: walks,
      process: ProcessWalk(
        mapData: map,
        discover: DiscoverSegments(
          repository: InMemoryKnownSegmentsRepository(),
        ),
        classify: const ClassifySegments(),
        creatures: InMemoryCreatureRepository(),
        summaries: FakeWalkSummaryRepository(),
      ),
    );
    await walks.saveFinished(
      Track(
        id: 'gang',
        points: [for (var m = 0; m <= 100; m += 7) eastOf(m.toDouble(), m)],
      ),
    );

    expect(await processor.processAll(), isEmpty);
    expect(await walks.pending(), hasLength(1));

    map.offline = false;
    final results = await processor.processAll();
    expect(results.single.newSegmentCount, 1);
    expect(await walks.pending(), isEmpty);
  });
}
