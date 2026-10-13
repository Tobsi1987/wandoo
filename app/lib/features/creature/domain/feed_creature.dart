import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/creature/domain/creature.dart';
import 'package:wandoo/features/creature/domain/trait.dart';

/// Füttert das Wesen nach einem Gang.
///
/// Jeder Weg macht satt, auch ein schon bekannter: Das Wesen wird dann
/// nicht träge. Wachsen lassen es nur neue Abschnitte, und ihre Umgebung
/// stärkt das passende Merkmal.
class FeedCreature {
  const FeedCreature({this.foodPerSegment = 1});

  final int foodPerSegment;

  Creature call(
    Creature creature,
    Map<EnvironmentType, int> newSegmentsByEnvironment,
    DateTime now, {
    int knownSegments = 0,
  }) {
    final total = newSegmentsByEnvironment.values.fold(0, (a, b) => a + b);
    if (total == 0) {
      return knownSegments > 0 ? creature.copyWith(lastFedAt: now) : creature;
    }

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
