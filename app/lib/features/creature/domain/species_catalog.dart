import 'dart:math';

import 'package:wandoo/features/creature/domain/rarity.dart';
import 'package:wandoo/features/creature/domain/species.dart';

/// Alle Tierarten. Neue Arten kommen nur hier dazu (und ihr Aussehen in
/// `presentation/species_looks.dart`); ids nie ändern oder wiederverwenden.
abstract final class SpeciesCatalog {
  static const all = <Species>[
    Species(id: 'aehrenhase', name: 'Ährenhäschen', rarity: Rarity.common),
    Species(id: 'moosbaer', name: 'Moosbärchen', rarity: Rarity.common),
    Species(id: 'axolotl', name: 'Wasser-Axolotl', rarity: Rarity.rare),
    Species(id: 'waschbaer', name: 'Laternen-Waschbär', rarity: Rarity.epic),
  ];

  /// Für Spielstände ohne gespeicherte Art.
  static Species get fallback => all.first;

  static Species byId(String? id) =>
      all.firstWhere((s) => s.id == id, orElse: () => fallback);

  /// Zieht zufällig eine Art: erst die Seltenheit nach ihrem Gewicht, dann
  /// eine Art daraus. Seltenheiten ohne Arten nehmen nicht teil.
  static Species pick(Random random, {List<Species> from = all}) {
    final rarities = {for (final s in from) s.rarity}.toList()
      ..sort((a, b) => a.index.compareTo(b.index));
    final total = rarities.fold(0, (sum, r) => sum + r.weight);
    var roll = random.nextInt(total);
    var rarity = rarities.last;
    for (final r in rarities) {
      if (roll < r.weight) {
        rarity = r;
        break;
      }
      roll -= r.weight;
    }
    final pool = from.where((s) => s.rarity == rarity).toList();
    return pool[random.nextInt(pool.length)];
  }
}
