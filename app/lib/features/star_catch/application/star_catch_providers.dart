import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/star_catch/domain/star_catch_repository.dart';
import 'package:wandoo/features/star_catch/domain/star_rain.dart';
import 'package:wandoo/features/treasure/treasure.dart';
import 'package:wandoo/features/walk_summary/walk_summary.dart';

/// Wird in `bootstrap/providers.dart` mit einer Umsetzung belegt.
final starCatchRepositoryProvider = Provider<StarCatchRepository>(
  (ref) => throw UnimplementedError('In bootstrap/providers.dart setzen.'),
);

final _lastWalkProvider = StreamProvider<String?>(
  (ref) => ref.watch(starCatchRepositoryProvider).watchLastWalk(),
);

/// Der Gang, nach dem jetzt gespielt werden darf, sonst null.
final starCatchWalkProvider = Provider<String?>((ref) {
  final summary = ref.watch(latestUnseenSummaryProvider).value;
  final creature = ref.watch(creatureProvider).value;
  final last = ref.watch(_lastWalkProvider);
  if (summary == null || creature == null || !creature.hatched) return null;
  if (!last.hasValue || last.value == summary.walkId) return null;
  return summary.walkId;
});

final finishStarCatchProvider = Provider<FinishStarCatch>(
  (ref) => FinishStarCatch(
    ref.watch(starCatchRepositoryProvider),
    ref.watch(treasureRepositoryProvider),
  ),
);

/// Nach dem Spiel: einmal je Gang, und gute Fänger bekommen Sternsplitter.
class FinishStarCatch {
  const FinishStarCatch(this._games, this._chests);

  final StarCatchRepository _games;
  final TreasureRepository _chests;

  /// Gibt die Zahl der verdienten Sternsplitter zurück.
  Future<int> call(String walkId, int caught) async {
    if (await _games.lastWalk() == walkId) return 0;
    await _games.playedAfter(walkId);
    final shards = shardsFor(caught);
    if (shards > 0) {
      final chest = await _chests.load();
      await _chests.save(chest.add(List.filled(shards, Find.starShard)));
    }
    return shards;
  }
}
