import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/hunger/hunger.dart';

/// Schaut nach dem Hunger: Ein frisch geschlüpftes Wesen bekommt einen
/// vollen Balken. War er zwei Tage leer, zieht das Wesen aus und lässt
/// einen Brief und ein neues Ei da.
class CheckHunger {
  CheckHunger({
    required this.creatures,
    required this.bellies,
    required this.clock,
    this.release = const ReleaseCreature(),
  });

  final CreatureRepository creatures;
  final BellyRepository bellies;
  final DateTime Function() clock;
  final ReleaseCreature release;

  /// Gibt den Brief zurück, wenn das Wesen ausgezogen ist.
  Future<Farewell?> call() async {
    final creature = await creatures.load();
    if (!creature.hatched) return null;
    final now = clock();
    final belly = await bellies.load();
    if (belly == null || belly.lineKey != creature.lineKey) {
      await bellies.save(Belly.full(creature.lineKey, now));
      return null;
    }
    if (!belly.leavesBy(now)) return null;
    final letter = Farewell(speciesId: creature.speciesId ?? '', at: now);
    await bellies.leaveLetter(letter);
    await creatures.save(release.runAway(creature, now));
    return letter;
  }
}
