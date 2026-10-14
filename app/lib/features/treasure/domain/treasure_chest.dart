import 'package:wandoo/features/treasure/domain/accessory.dart';
import 'package:wandoo/features/treasure/domain/find.dart';

/// Alle gesammelten Fundstücke, Baupläne und die schon gebastelte Deko.
class TreasureChest {
  const TreasureChest({
    this.finds = const {},
    this.owned = const {},
    this.plans = const {},
  });

  final Map<Find, int> finds;
  final Set<Accessory> owned;

  /// Baupläne für seltene Teile.
  final Set<Accessory> plans;

  int count(Find find) => finds[find] ?? 0;

  /// Ob der Bauplan da ist (oder keiner nötig).
  bool knows(Accessory a) => !a.plan || plans.contains(a);

  bool canCraft(Accessory a) =>
      !owned.contains(a) &&
      knows(a) &&
      a.recipe.entries.every((e) => count(e.key) >= e.value);

  TreasureChest add(Iterable<Find> found) {
    final next = Map<Find, int>.of(finds);
    for (final f in found) {
      next.update(f, (n) => n + 1, ifAbsent: () => 1);
    }
    return _with(finds: next);
  }

  /// Bekommt [a] geschenkt, zum Beispiel als Level-Belohnung.
  TreasureChest gift(Accessory a) => _with(owned: {...owned, a});

  /// Bekommt den Bauplan für [a].
  TreasureChest learn(Accessory a) => _with(plans: {...plans, a});

  /// Bastelt [a] aus den Fundstücken. Wirft, wenn es nicht reicht.
  TreasureChest craft(Accessory a) {
    if (!canCraft(a)) throw StateError('${a.name} geht noch nicht.');
    return _with(
      finds: {
        ...finds,
        for (final e in a.recipe.entries) e.key: count(e.key) - e.value,
      },
      owned: {...owned, a},
    );
  }

  TreasureChest _with({
    Map<Find, int>? finds,
    Set<Accessory>? owned,
    Set<Accessory>? plans,
  }) => TreasureChest(
    finds: finds ?? this.finds,
    owned: owned ?? this.owned,
    plans: plans ?? this.plans,
  );
}
