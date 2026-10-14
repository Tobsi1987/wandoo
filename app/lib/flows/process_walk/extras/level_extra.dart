import 'package:wandoo/features/levels/levels.dart';
import 'package:wandoo/features/scent/scent.dart';
import 'package:wandoo/flows/levels/gain_xp.dart';
import 'package:wandoo/flows/process_walk/walk_extra.dart';

/// Erfahrung aus dem Gang: Meter, neue Straßenstücke und ein
/// erschnüffelter Fund. Läuft vor der Spürnase, die den Fund wegräumt.
class LevelExtra implements WalkExtra {
  LevelExtra({required this.gain, required this.scents});

  final GainXp gain;
  final ScentRepository scents;

  @override
  Future<List<String>> onWalk(WalkOutcome outcome) async {
    final summary = outcome.summary;
    final scent = await scents.load();
    final sniffed = scent != null && scent.reachedBy(outcome.track);
    final xp =
        Xp.forWalk(
          meters: summary.distanceMeters,
          newSegments: summary.newSegmentCount,
        ) +
        (sniffed ? Xp.scent : 0);
    return await gain(outcome.after, xp);
  }
}
