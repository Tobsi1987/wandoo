import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/petting/petting.dart';
import 'package:wandoo/flows/process_walk/walk_extra.dart';

/// Jeder gemeinsame Gang macht die Freundschaft stärker; ein neues Herz
/// steht in der Zusammenfassung.
class FriendshipExtra implements WalkExtra {
  const FriendshipExtra(
    this.friendships, {
    this.rules = const BefriendCreature(),
  });

  final FriendshipRepository friendships;
  final BefriendCreature rules;

  @override
  Future<List<String>> onWalk(WalkOutcome outcome) async {
    final creature = outcome.after;
    if (!creature.hatched) return const [];
    final before = await friendships.load(creature.lineKey);
    final after = rules.walked(before);
    await friendships.save(after);
    if (after.hearts <= before.hearts) return const [];
    final name = SpeciesCatalog.byId(creature.speciesId).name;
    final hearts = after.hearts == 1 ? '1 Herz' : '${after.hearts} Herzen';
    return ['💗 $name hat dich noch lieber: $hearts'];
  }
}
