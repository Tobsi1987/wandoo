import 'dart:math';

import 'package:wandoo/features/creature/domain/rarity.dart';
import 'package:wandoo/features/creature/domain/species.dart';

/// Alle Tierarten. Neue Arten kommen nur hier dazu (und ihr Aussehen in
/// `presentation/species_looks.dart`); ids nie ändern oder wiederverwenden.
/// Unbekannte ids (z. B. die vier Platzhalter-Arten vor den 20 Wesen)
/// werden über [byId] zu [fallback].
abstract final class SpeciesCatalog {
  static const all = <Species>[
    Species(id: 'funkel', name: 'Funkel', rarity: Rarity.common),
    Species(id: 'moosel', name: 'Moosel', rarity: Rarity.common),
    Species(id: 'pfuetzling', name: 'Pfützling', rarity: Rarity.common),
    Species(id: 'kieselchen', name: 'Kieselchen', rarity: Rarity.common),
    Species(id: 'pustel', name: 'Pustel', rarity: Rarity.common),
    Species(id: 'schnirp', name: 'Schnirp', rarity: Rarity.common),
    Species(id: 'brummli', name: 'Brummli', rarity: Rarity.common),
    Species(id: 'zapfi', name: 'Zapfi', rarity: Rarity.common),
    Species(id: 'laternchen', name: 'Laternchen', rarity: Rarity.common),
    Species(id: 'wolkenwuff', name: 'Wolkenwuff', rarity: Rarity.rare),
    Species(id: 'blitzmaus', name: 'Blitzmaus', rarity: Rarity.rare),
    Species(id: 'blaetterdrache', name: 'Blätterdrache', rarity: Rarity.rare),
    Species(id: 'pilzling', name: 'Pilzling', rarity: Rarity.rare),
    Species(id: 'kristallis', name: 'Kristallis', rarity: Rarity.rare),
    Species(id: 'fluffeule', name: 'Fluffeule', rarity: Rarity.rare),
    Species(id: 'nebelfuchs', name: 'Nebelfuchs', rarity: Rarity.epic),
    Species(id: 'glutling', name: 'Glutling', rarity: Rarity.epic),
    Species(id: 'wellenwal', name: 'Wellenwal', rarity: Rarity.epic),
    Species(id: 'aurora', name: 'Aurora', rarity: Rarity.epic),
    Species(
      id: 'sternschnuppe',
      name: 'Sternschnuppe',
      rarity: Rarity.legendary,
    ),
  ];

  /// Für Spielstände ohne gespeicherte Art.
  static Species get fallback => all.first;

  static Species byId(String? id) =>
      all.firstWhere((s) => s.id == id, orElse: () => fallback);

  /// Zieht zufällig eine Art: erst die Seltenheit nach ihrem Gewicht, dann
  /// eine Art daraus. Seltenheiten ohne Arten nehmen nicht teil. Ein
  /// Glücks-Ei ([lucky]) lässt gewöhnliche Arten aus.
  static Species pick(
    Random random, {
    List<Species> from = all,
    bool lucky = false,
  }) {
    final pool = lucky && from.any((s) => s.rarity != Rarity.common)
        ? from.where((s) => s.rarity != Rarity.common).toList()
        : from;
    return _pickFrom(pool, random);
  }

  static Species _pickFrom(List<Species> from, Random random) {
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
