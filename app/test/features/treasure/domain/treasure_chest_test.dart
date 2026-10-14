import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/treasure/treasure.dart';

void main() {
  test('Funde werden gezählt', () {
    final chest = const TreasureChest().add([
      Find.acorn,
      Find.acorn,
      Find.shell,
    ]);
    expect(chest.count(Find.acorn), 2);
    expect(chest.count(Find.shell), 1);
    expect(chest.count(Find.poppy), 0);
  });

  test('Basteln kostet Funde und gehört dann dem Wesen', () {
    final chest = const TreasureChest().add(List.filled(4, Find.acorn));
    expect(chest.canCraft(Accessory.acornCap), isTrue);
    final after = chest.craft(Accessory.acornCap);
    expect(after.count(Find.acorn), 1);
    expect(after.owned, {Accessory.acornCap});
    expect(after.canCraft(Accessory.acornCap), isFalse);
  });

  test('zu wenig Funde: nicht bastelbar', () {
    final chest = const TreasureChest().add([Find.shell]);
    expect(chest.canCraft(Accessory.shellNecklace), isFalse);
    expect(() => chest.craft(Accessory.shellNecklace), throwsStateError);
  });

  test('gemischte Rezepte brauchen alle Zutaten', () {
    final chest = const TreasureChest().add([
      ...List.filled(6, Find.acorn),
      ...List.filled(2, Find.poppy),
    ]);
    expect(chest.canCraft(Accessory.mushroomCap), isFalse);
    final more = chest.add([Find.poppy]);
    final after = more.craft(Accessory.mushroomCap);
    expect(after.count(Find.acorn), 0);
    expect(after.count(Find.poppy), 0);
  });

  test('seltene Teile brauchen zuerst einen Bauplan', () {
    final chest = const TreasureChest().add([
      ...List.filled(10, Find.sparkle),
      Find.starShard,
    ]);
    expect(Accessory.topHat.tier, CraftTier.rare);
    expect(chest.canCraft(Accessory.topHat), isFalse);
    expect(chest.learn(Accessory.topHat).canCraft(Accessory.topHat), isTrue);
  });

  test('jedes Teil hat ein passendes Stück am Wesen', () {
    for (final a in Accessory.values) {
      expect(hatFor(a) ?? neckFor(a), isNotNull, reason: a.name);
    }
  });
}
