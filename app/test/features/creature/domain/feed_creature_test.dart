import 'package:flutter_test/flutter_test.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/creature/creature.dart';

void main() {
  final now = DateTime(2026, 10, 12);
  const feed = FeedCreature();

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
    const creature = Creature(food: 5, traitPoints: {Trait.moss: 5});
    final fed = feed(creature, const {}, now, knownSegments: 7);
    expect(fed.food, 5);
    expect(fed.traitPoints, {Trait.moss: 5});
    expect(fed.lastFedAt, now);
    expect(fed.isSluggish(now.add(const Duration(days: 1))), isFalse);
  });

  test('wächst vom Ei zum Jungtier', () {
    final fed = feed(const Creature(food: 18), {EnvironmentType.city: 2}, now);
    expect(fed.stage, GrowthStage.juvenile);
  });

  test('wird nach drei Tagen ohne Neues träge', () {
    final creature = Creature(lastFedAt: now);
    expect(creature.isSluggish(now.add(const Duration(days: 2))), isFalse);
    expect(creature.isSluggish(now.add(const Duration(days: 4))), isTrue);
  });
}
