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
import 'package:wandoo/features/adventures/adventures.dart';
import 'package:wandoo/features/adventures/data/in_memory_adventure_repository.dart';
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
import 'package:wandoo/features/world/world.dart';

/// Wie `appOverrides`, aber alles im Speicher und ohne Gerät: eine erfundene
/// Stadt, simulierte Gänge, keine Datenbank, kein Netz.
List<Override> demoOverrides() => [
  creatureRepositoryProvider.overrideWithValue(
    InMemoryCreatureRepository(_startCreature()),
  ),
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
  adventureRepositoryProvider.overrideWithValue(InMemoryAdventureRepository()),
  feedCreatureProvider.overrideWithValue(
    FeedCreature(hatchFrom: [SpeciesCatalog.byId(_hatches())]),
  ),
  if (_hour() case final hour?)
    worldClockProvider.overrideWithValue(() {
      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day, hour, now.minute);
    }),
];

/// `?uhr=8` zeigt die Welt um 8 Uhr, egal wie spät es ist.
int? _hour() => int.tryParse(Uri.base.queryParameters['uhr'] ?? '');

class _DemoMapData implements MapDataSource {
  @override
  Future<List<RoadSegment>> segmentsNear(List<GeoPoint> points) async =>
      DemoTown.segments;
}

/// Was in der Demo aus dem Ei schlüpft: `?ei=funkel`, sonst Aurora (das
/// erste Wesen mit Rig und Animationen).
String _hatches() => Uri.base.queryParameters['ei'] ?? 'aurora';

/// `?wesen=funkel` startet die Demo mit diesem Wesen geschlüpft und allen
/// Arten im Album, um die 3D-Modelle anzusehen. Ohne Angabe: ein Ei, das
/// schon nach dem ersten Gang schlüpft.
Creature _startCreature() {
  final query = Uri.base.queryParameters;
  final id = query['wesen'];
  if (id == null) return const Creature(food: 16);
  return Creature(
    food: GrowthStage.adult.foodNeeded,
    speciesId: SpeciesCatalog.byId(id).id,
    seenSpecies: {for (final s in SpeciesCatalog.all) s.id},
    hat: _named(CreatureHat.values, query['hut']),
    neck: _named(CreatureNeck.values, query['hals']),
  );
}

T? _named<T extends Enum>(List<T> values, String? name) =>
    values.where((v) => v.name == name).firstOrNull;
