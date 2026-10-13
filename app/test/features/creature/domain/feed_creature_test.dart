import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/creature/creature.dart';

void main() {
  final now = DateTime(2026, 10, 12);
  final feed = FeedCreature(random: Random(1));

  test('neue Waldabschnitte füttern und stärken Moos', () {
    final fed = feed(const Creature(), {EnvironmentType.forest: 3}, now);
    expect(fed.food, 3);
    expect(fed.traitPoints, {Trait.moss: 3});
    expect(fed.dominantTrait, Trait.moss);
    expect(fed.lastFedAt, now);
  });

  test('ohne Neues bleibt das Wesen unverändert', () {
    const creature = Creature(food: 5);
    expect(identical(feed(creature, const {}, now), creature), isTrue);
  });

  test('bekannte Wege machen satt, lassen aber nicht wachsen', () {
    const creature = Creature(
      food: 25,
      speciesId: 'funkel',
      traitPoints: {Trait.moss: 5},
    );
    final fed = feed(creature, const {}, now, knownSegments: 7);
    expect(fed.food, 25);
    expect(fed.traitPoints, {Trait.moss: 5});
    expect(fed.lastFedAt, now);
    expect(fed.isSluggish(now.add(const Duration(days: 1))), isFalse);
  });

  test('bekannte Wege wärmen ein Ei bis zum Schlüpfen', () {
    final warm = feed(const Creature(food: 5), const {}, now, knownSegments: 7);
    expect(warm.food, 12);
    expect(warm.hatched, isFalse);
    final hatched = feed(
      warm,
      {EnvironmentType.city: 2},
      now,
      knownSegments: 30,
    );
    expect(hatched.food, GrowthStage.juvenile.foodNeeded);
    expect(hatched.speciesId, isNotNull);
  });

  test('wächst vom Ei zum Jungtier', () {
    final fed = feed(const Creature(food: 18), {EnvironmentType.city: 2}, now);
    expect(fed.stage, GrowthStage.juvenile);
  });

  test('beim Schlüpfen wird eine Art gezogen, die dann bleibt', () {
    final egg = feed(const Creature(food: 10), {EnvironmentType.water: 4}, now);
    expect(egg.speciesId, isNull);
    final hatched = feed(egg, {EnvironmentType.water: 6}, now);
    expect(SpeciesCatalog.all.map((s) => s.id), contains(hatched.speciesId));
    final later = feed(hatched, {EnvironmentType.forest: 50}, now);
    expect(later.speciesId, hatched.speciesId);
  });

  test('geschlüpfte Art landet im Album, ein Glücks-Ei wird verbraucht', () {
    const lucky = Creature(food: 19, luckyEgg: true, seenSpecies: {'moosel'});
    final hatched = feed(lucky, {EnvironmentType.field: 1}, now);
    final species = SpeciesCatalog.byId(hatched.speciesId);
    expect(species.rarity, isNot(Rarity.common));
    expect(hatched.seenSpecies, {'moosel', species.id});
    expect(hatched.luckyEgg, isFalse);
  });

  test('alte Spielstände ohne Art bekommen beim nächsten Gang eine', () {
    const old = Creature(food: 30, traitPoints: {Trait.moss: 30});
    final fed = feed(old, {EnvironmentType.forest: 1}, now);
    expect(fed.speciesId, isNotNull);
  });

  test('wird nach drei Tagen ohne Neues träge', () {
    final creature = Creature(lastFedAt: now);
    expect(creature.isSluggish(now.add(const Duration(days: 2))), isFalse);
    expect(creature.isSluggish(now.add(const Duration(days: 4))), isTrue);
  });
}
