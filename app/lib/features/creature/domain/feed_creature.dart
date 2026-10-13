import 'dart:math';

import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/creature/domain/creature.dart';
import 'package:wandoo/features/creature/domain/growth_stage.dart';
import 'package:wandoo/features/creature/domain/species_catalog.dart';
import 'package:wandoo/features/creature/domain/trait.dart';

/// Füttert das Wesen nach einem Gang.
///
/// Jeder Weg macht satt, auch ein schon bekannter: Das Wesen wird dann
/// nicht träge. Wachsen lassen es nur neue Abschnitte, und ihre Umgebung
/// stärkt das passende Merkmal.
///
/// Ein Ei wärmt dagegen jeder Weg: Sonst schlüpft ein zweites Ei kaum
/// noch, wenn die Gegend schon bekannt ist.
class FeedCreature {
  FeedCreature({this.foodPerSegment = 1, Random? random})
    : _random = random ?? Random();

  final int foodPerSegment;
  final Random _random;

  Creature call(
    Creature creature,
    Map<EnvironmentType, int> newSegmentsByEnvironment,
    DateTime now, {
    int knownSegments = 0,
  }) {
    final total = newSegmentsByEnvironment.values.fold(0, (a, b) => a + b);
    final warmth = _warmth(creature, total, knownSegments);
    if (total == 0) {
      if (knownSegments == 0) return creature;
      return _hatch(
        creature.copyWith(food: creature.food + warmth, lastFedAt: now),
      );
    }

    final traits = Map<Trait, int>.of(creature.traitPoints);
    newSegmentsByEnvironment.forEach((type, count) {
      final trait = Trait.forEnvironment(type);
      if (trait != null) {
        traits.update(trait, (n) => n + count, ifAbsent: () => count);
      }
    });
    final fed = creature.copyWith(
      food: creature.food + total * foodPerSegment + warmth,
      traitPoints: traits,
      lastFedAt: now,
    );
    return _hatch(fed);
  }

  /// Was bekannte Wege einem Ei bringen, höchstens bis zum Schlüpfen.
  int _warmth(Creature creature, int fresh, int known) {
    if (creature.hatched || known == 0) return 0;
    final missing =
        GrowthStage.juvenile.foodNeeded -
        creature.food -
        fresh * foodPerSegment;
    return missing <= 0 ? 0 : min(known * foodPerSegment, missing);
  }

  /// Schlüpft das Ei, wird die Tierart zufällig gezogen und bleibt dann.
  Creature _hatch(Creature after) {
    if (!after.hatched || after.speciesId != null) return after;
    final species = SpeciesCatalog.pick(_random, lucky: after.luckyEgg);
    return after.copyWith(
      speciesId: species.id,
      seenSpecies: {...after.seenSpecies, species.id},
      luckyEgg: false,
    );
  }
}
