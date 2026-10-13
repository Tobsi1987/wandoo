import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/walk_summary/domain/walk_summary.dart';

/// Fasst die neu entdeckten Abschnitte eines Gangs zusammen.
class SummarizeWalk {
  const SummarizeWalk();

  WalkSummary call({
    required String walkId,
    required DateTime finishedAt,
    required Map<RoadSegment, EnvironmentType> newSegments,
    required bool creatureGrew,
    int knownSegmentCount = 0,
  }) {
    final streetsByEnvironment = <EnvironmentType, Set<String>>{};
    newSegments.forEach((segment, type) {
      if (type == EnvironmentType.unknown) return;
      streetsByEnvironment.putIfAbsent(type, () => {}).add(segment.streetId);
    });
    final segments = newSegments.keys;
    return WalkSummary(
      walkId: walkId,
      finishedAt: finishedAt,
      newSegmentCount: newSegments.length,
      knownSegmentCount: knownSegmentCount,
      newStreetCount: {for (final s in segments) s.streetId}.length,
      streetsByEnvironment: {
        for (final e in streetsByEnvironment.entries) e.key: e.value.length,
      },
      bridgeCount: {
        for (final s in segments)
          if (s.areaTags['bridge'] == 'yes') s.streetId,
      }.length,
      creatureGrew: creatureGrew,
    );
  }
}
