import 'package:wandoo/features/treasure/domain/accessory.dart';
import 'package:wandoo/features/treasure/domain/find.dart';

/// Alle gesammelten Fundstücke und die schon gebastelte Deko.
class TreasureChest {
  const TreasureChest({this.finds = const {}, this.owned = const {}});

  final Map<Find, int> finds;
  final Set<Accessory> owned;

  int count(Find find) => finds[find] ?? 0;

  bool canCraft(Accessory a) =>
      !owned.contains(a) && count(a.material) >= a.cost;

  TreasureChest add(Iterable<Find> found) {
    final next = Map<Find, int>.of(finds);
    for (final f in found) {
      next.update(f, (n) => n + 1, ifAbsent: () => 1);
    }
    return TreasureChest(finds: next, owned: owned);
  }

  /// Bekommt [a] geschenkt, zum Beispiel als Level-Belohnung.
  TreasureChest gift(Accessory a) =>
      TreasureChest(finds: finds, owned: {...owned, a});

  /// Bastelt [a] aus den Fundstücken. Wirft, wenn es nicht reicht.
  TreasureChest craft(Accessory a) {
    if (!canCraft(a)) throw StateError('Zu wenig ${a.material.name}.');
    return TreasureChest(
      finds: {...finds, a.material: count(a.material) - a.cost},
      owned: {...owned, a},
    );
  }
}
