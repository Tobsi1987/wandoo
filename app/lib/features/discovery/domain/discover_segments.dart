import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/discovery/domain/known_segments_repository.dart';

/// Findet die neu entdeckten Abschnitte einer Spur und merkt sie sich.
class DiscoverSegments {
  const DiscoverSegments({
    required this.repository,
    this.matcher = const NearestSegmentMatcher(),
    this.novelty = const NoveltyEvaluator(),
  });

  final KnownSegmentsRepository repository;
  final MapMatcher matcher;
  final NoveltyEvaluator novelty;

  Future<List<RoadSegment>> call(
    Track track,
    List<RoadSegment> candidates,
  ) async {
    final walked = matcher.match(track, candidates);
    final result = novelty.evaluate(
      walked: walked,
      known: await repository.knownIds(),
    );
    await repository.addAll(result.newIds);
    return [
      for (final segment in candidates)
        if (result.newIds.contains(segment.id)) segment,
    ];
  }
}
