import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/scent/scent.dart';
import 'package:wandoo/features/treasure/treasure.dart';
import 'package:wandoo/flows/process_walk/walk_extra.dart';
import 'package:wandoo/flows/scent/sniff_out.dart';

/// Spürnase nach dem Gang: Wer am Fund vorbeikam, bekommt ihn. Danach
/// riecht das Wesen schon die nächste Spur, für den nächsten Gang.
class ScentExtra implements WalkExtra {
  ScentExtra({
    required this.scents,
    required this.chests,
    required this.sniff,
    this.findsPerScent = 2,
  });

  final ScentRepository scents;
  final TreasureRepository chests;
  final SniffOut sniff;
  final int findsPerScent;

  @override
  Future<List<String>> onWalk(WalkOutcome outcome) async {
    final lines = <String>[];
    final scent = await scents.load();
    final creature = outcome.after;
    if (scent != null && creature.hatched && scent.reachedBy(outcome.track)) {
      final found = List.filled(
        findsPerScent,
        Find.rewardFor(scent.environment),
      );
      final chest = await chests.load();
      await chests.save(chest.add(found));
      await scents.clear();
      final name = SpeciesCatalog.byId(creature.speciesId).name;
      lines.add('👃 $name hat erschnüffelt: ${foundLines(found).join(', ')}');
    }
    final end = outcome.track.positions.lastOrNull;
    if (creature.hatched && end != null) {
      await sniff(end, outcome.summary.finishedAt);
    }
    return lines;
  }
}
