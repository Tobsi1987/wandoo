import 'package:wandoo/features/creature/domain/creature.dart';
import 'package:wandoo/features/creature/domain/growth_stage.dart';

/// Schickt ein geschlüpftes Wesen in die Wildnis. Danach liegt ein neues
/// Ei bereit, und erst nach [cooldown] darf wieder eines gehen.
class ReleaseCreature {
  const ReleaseCreature({this.cooldown = const Duration(days: 7)});

  final Duration cooldown;

  /// Wie lange noch gewartet werden muss; [Duration.zero], wenn es geht.
  Duration waitLeft(Creature creature, DateTime now) {
    final last = creature.lastReleasedAt;
    if (last == null) return Duration.zero;
    final left = last.add(cooldown).difference(now);
    return left.isNegative ? Duration.zero : left;
  }

  bool canRelease(Creature creature, DateTime now) =>
      creature.stage != GrowthStage.egg &&
      waitLeft(creature, now) == Duration.zero;

  /// Das neue Ei. Wirft, wenn [canRelease] nein sagt.
  Creature call(Creature creature, DateTime now) {
    if (!canRelease(creature, now)) {
      throw StateError('Wegschicken ist gerade nicht möglich.');
    }
    return Creature(
      lastReleasedAt: now,
      seenSpecies: creature.seenSpecies,
      luckyEgg: creature.luckyEgg,
    );
  }
}
