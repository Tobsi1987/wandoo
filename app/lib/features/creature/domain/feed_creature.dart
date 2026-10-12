import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/creature/domain/creature.dart';
import 'package:wandoo/features/creature/domain/trait.dart';

/// Füttert das Wesen mit den neuen Abschnitten eines Gangs.
///
/// Jeder neue Abschnitt ist Futter, und seine Umgebung stärkt das
/// passende Merkmal. Bekannte Wege kommen hier gar nicht erst an.
class FeedCreature {
  const FeedCreature({this.foodPerSegment = 1});

  final int foodPerSegment;

  Creature call(
    Creature creature,
    Map<EnvironmentType, int> newSegmentsByEnvironment,
    DateTime now,
  ) {
    final total = newSegmentsByEnvironment.values.fold(0, (a, b) => a + b);
    if (total == 0) return creature;

    final traits = Map<Trait, int>.of(creature.traitPoints);
    newSegmentsByEnvironment.forEach((type, count) {
      final trait = Trait.forEnvironment(type);
      if (trait != null) {
        traits.update(trait, (n) => n + count, ifAbsent: () => count);
      }
    });
    return creature.copyWith(
      food: creature.food + total * foodPerSegment,
      traitPoints: traits,
      lastFedAt: now,
    );
  }
}
