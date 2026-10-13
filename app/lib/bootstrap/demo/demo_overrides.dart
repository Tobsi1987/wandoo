import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/bootstrap/demo/demo_platform.dart';
import 'package:wandoo/bootstrap/demo/demo_town.dart';
import 'package:wandoo/bootstrap/demo/in_memory_recorded_walk_repository.dart';
import 'package:wandoo/bootstrap/demo/in_memory_walk_summary_repository.dart';
import 'package:wandoo/bootstrap/demo/simulated_location_source.dart';
import 'package:wandoo/core/location/location_providers.dart';
import 'package:wandoo/core/map_data/map_data_providers.dart';
import 'package:wandoo/core/map_data/map_data_source.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/creature/data/in_memory_creature_repository.dart';
import 'package:wandoo/features/discovery/data/in_memory_known_segments_repository.dart';
import 'package:wandoo/features/discovery/discovery.dart';
import 'package:wandoo/features/discovery_map/discovery_map.dart';
import 'package:wandoo/features/home_widget/home_widget.dart';
import 'package:wandoo/features/reminders/reminders.dart';
import 'package:wandoo/features/share/data/share_plus_image_sharer.dart';
import 'package:wandoo/features/share/share.dart';
import 'package:wandoo/features/tracking/tracking.dart';
import 'package:wandoo/features/treasure/data/in_memory_treasure_repository.dart';
import 'package:wandoo/features/treasure/treasure.dart';
import 'package:wandoo/features/walk_summary/walk_summary.dart';

/// Wie `appOverrides`, aber alles im Speicher und ohne Gerät: eine erfundene
/// Stadt, simulierte Gänge, keine Datenbank, kein Netz.
List<Override> demoOverrides() => [
  creatureRepositoryProvider.overrideWithValue(InMemoryCreatureRepository()),
  knownSegmentsRepositoryProvider.overrideWithValue(
    InMemoryKnownSegmentsRepository(),
  ),
  mapDataSourceProvider.overrideWithValue(_DemoMapData()),
  locationSourceProvider.overrideWithValue(SimulatedLocationSource()),
  showBaseMapProvider.overrideWithValue(false),
  imageSharerProvider.overrideWithValue(const SharePlusImageSharer()),
  reminderSchedulerProvider.overrideWithValue(LoggingReminderScheduler()),
  widgetPublisherProvider.overrideWithValue(LoggingWidgetPublisher()),
  recordedWalkRepositoryProvider.overrideWithValue(
    InMemoryRecordedWalkRepository(),
  ),
  walkSummaryRepositoryProvider.overrideWithValue(
    InMemoryWalkSummaryRepository(),
  ),
  treasureRepositoryProvider.overrideWithValue(InMemoryTreasureRepository()),
];

class _DemoMapData implements MapDataSource {
  @override
  Future<List<RoadSegment>> segmentsNear(List<GeoPoint> points) async =>
      DemoTown.segments;
}
