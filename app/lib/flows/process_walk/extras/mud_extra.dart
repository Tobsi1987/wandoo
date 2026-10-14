import 'package:wandoo/features/bath/bath.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/world/world.dart';
import 'package:wandoo/flows/process_walk/walk_extra.dart';

/// Nach Wald-, Feld- oder Regenwegen wird das Wesen schmutzig und will
/// gebadet werden.
class MudExtra implements WalkExtra {
  MudExtra(this.mud, {required this.weather});

  final MudRepository mud;

  /// Das Wetter jetzt, also direkt nach dem Gang.
  final Weather? Function() weather;

  @override
  Future<List<String>> onWalk(WalkOutcome outcome) async {
    final creature = outcome.after;
    if (!creature.hatched) return const [];
    final key = creature.lineKey;
    final before = await mud.load(key);
    final now = Mud.afterWalk(
      before,
      meters: outcome.summary.distanceMeters,
      newStreets: outcome.newSegmentsByEnvironment,
      rainy: weather() == Weather.rain || weather() == Weather.storm,
    );
    if (now == before) return const [];
    await mud.save(key, now);
    final name = SpeciesCatalog.byId(creature.speciesId).name;
    final how = now == Mud.max ? 'ganz matschig' : 'schmutzig';
    return ['🛁 $name ist $how: ab in die Wanne im Zuhause!'];
  }
}
