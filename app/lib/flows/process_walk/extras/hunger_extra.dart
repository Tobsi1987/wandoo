import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/hunger/hunger.dart';
import 'package:wandoo/flows/process_walk/walk_extra.dart';

/// Jeder Meter Gehen füllt den Hungerbalken, auch auf bekannten Straßen.
class HungerExtra implements WalkExtra {
  HungerExtra(this.bellies, {required this.clock});

  final BellyRepository bellies;
  final DateTime Function() clock;

  @override
  Future<List<String>> onWalk(WalkOutcome outcome) async {
    final creature = outcome.after;
    if (!creature.hatched) return const [];
    final now = clock();
    final stored = await bellies.load();
    final belly = stored != null && stored.lineKey == creature.lineKey
        ? stored
        : Belly.full(creature.lineKey, now);
    final before = belly.fillAt(now);
    final after = belly.eat(outcome.summary.distanceMeters, now);
    await bellies.save(after);
    if (before >= 1 || outcome.summary.distanceMeters <= 0) return const [];
    final name = SpeciesCatalog.byId(creature.speciesId).name;
    final fill = after.fillAt(now);
    final line = fill >= 1
        ? '🍎 $name ist pappsatt!'
        : '🍎 $name hat gegessen: Bauch zu ${(fill * 100).round()} % voll';
    return [line];
  }
}
