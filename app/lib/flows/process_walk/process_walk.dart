import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/core/map_data/map_data_source.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/discovery/discovery.dart';
import 'package:wandoo/features/environment/environment.dart';
import 'package:wandoo/flows/process_walk/walk_result.dart';

/// Verarbeitet einen fertigen Gang: Spur, Entdeckung, Umgebung, Fütterung.
///
/// Der einzige Ort, der diese Features verbindet. Keines davon kennt die
/// anderen.
class ProcessWalk {
  const ProcessWalk({
    required this.mapData,
    required this.discover,
    required this.classify,
    required this.creatures,
    this.feed = const FeedCreature(),
  });

  final MapDataSource mapData;
  final DiscoverSegments discover;
  final ClassifySegments classify;
  final CreatureRepository creatures;
  final FeedCreature feed;

  Future<WalkResult> call(Track track, {DateTime? now}) async {
    final candidates = await mapData.segmentsNear(track.positions);
    final newSegments = await discover(track, candidates);
    final byEnvironment = classify(newSegments);
    final creature = feed(
      await creatures.load(),
      byEnvironment,
      now ?? DateTime.now(),
    );
    await creatures.save(creature);
    return WalkResult(
      newSegmentCount: newSegments.length,
      byEnvironment: byEnvironment,
      creature: creature,
    );
  }
}
