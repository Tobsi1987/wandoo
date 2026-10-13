import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/core/map_data/map_data_source.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/discovery/discovery.dart';
import 'package:wandoo/features/environment/environment.dart';
import 'package:wandoo/features/walk_summary/walk_summary.dart';
import 'package:wandoo/flows/process_walk/walk_extra.dart';
import 'package:wandoo/flows/process_walk/walk_result.dart';

/// Verarbeitet einen fertigen Gang: Spur, Entdeckung, Umgebung, Fütterung,
/// Zusammenfassung.
///
/// Der einzige Ort, der diese Features verbindet. Keines davon kennt die
/// anderen.
class ProcessWalk {
  ProcessWalk({
    required this.mapData,
    required this.discover,
    required this.classify,
    required this.creatures,
    required this.summaries,
    FeedCreature? feed,
    this.extras = const [],
    this.summarize = const SummarizeWalk(),
  }) : feed = feed ?? FeedCreature();

  final MapDataSource mapData;
  final DiscoverSegments discover;
  final ClassifySegments classify;
  final CreatureRepository creatures;
  final WalkSummaryRepository summaries;
  final FeedCreature feed;
  final SummarizeWalk summarize;

  /// Läuft nach jedem Gang, z. B. Fundstücke und Abenteuer.
  final List<WalkExtra> extras;

  Future<WalkResult> call(Track track, {DateTime? now}) async {
    final finishedAt = track.points.lastOrNull?.time ?? now ?? DateTime.now();
    final candidates = await mapData.segmentsNear(track.positions);
    final discovery = await discover(track, candidates);
    final newSegments = classify.each(discovery.fresh);

    final before = await creatures.load();
    final after = feed(
      before,
      _count(newSegments),
      now ?? DateTime.now(),
      knownSegments: discovery.knownCount,
    );
    await creatures.save(after);

    var summary = summarize(
      walkId: track.id,
      finishedAt: finishedAt,
      newSegments: newSegments,
      knownSegmentCount: discovery.knownCount,
      creatureGrew: after.stage != before.stage,
    );
    final outcome = WalkOutcome(
      track: track,
      summary: summary,
      newSegmentsByEnvironment: _count(newSegments),
    );
    for (final extra in extras) {
      summary = summary.withExtraLines(await extra.onWalk(outcome));
    }
    await summaries.save(summary);
    return WalkResult(summary: summary, creature: after);
  }

  static Map<EnvironmentType, int> _count(
    Map<RoadSegment, EnvironmentType> segments,
  ) {
    final counts = <EnvironmentType, int>{};
    for (final type in segments.values) {
      counts.update(type, (n) => n + 1, ifAbsent: () => 1);
    }
    return counts;
  }
}
