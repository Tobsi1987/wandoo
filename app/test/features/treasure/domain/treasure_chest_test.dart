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
}
