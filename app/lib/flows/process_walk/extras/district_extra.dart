import 'package:wandoo/features/discovery/discovery.dart';
import 'package:wandoo/features/districts/districts.dart';
import 'package:wandoo/flows/process_walk/walk_extra.dart';

/// Meldet Viertel, die mit diesem Gang ihr Abzeichen bekommen haben.
class DistrictExtra implements WalkExtra {
  const DistrictExtra(this.known, {this.progress = const DistrictProgress()});

  final KnownSegmentsRepository known;
  final DistrictProgress progress;

  @override
  Future<List<String>> onWalk(WalkOutcome outcome) async {
    if (outcome.freshIds.isEmpty) return const [];
    final badges = progress.newBadges(
      outcome.nearby,
      await known.knownIds(),
      outcome.freshIds,
    );
    return [for (final d in badges) badgeLine(d)];
  }
}
