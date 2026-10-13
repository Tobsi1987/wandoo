import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/creature/creature.dart';

void main() {
  test('ids sind eindeutig', () {
    final ids = SpeciesCatalog.all.map((s) => s.id).toList();
    expect(ids.toSet().length, ids.length);
  });

  test('Seltenheiten werden nach Gewicht gezogen', () {
    const species = [
      Species(id: 'a', name: 'A', rarity: Rarity.common),
      Species(id: 'b', name: 'B', rarity: Rarity.legendary),
    ];
    final random = Random(7);
    final counts = <String, int>{};
    for (var i = 0; i < 6200; i++) {
      final s = SpeciesCatalog.pick(random, from: species);
      counts.update(s.id, (n) => n + 1, ifAbsent: () => 1);
    }
    // 60 : 2, also etwa 200 legendäre von 6200.
    expect(counts['b'], inInclusiveRange(120, 300));
  });

  test('unbekannte id fällt auf eine gewöhnliche Art zurück', () {
    expect(SpeciesCatalog.byId('gibtsnicht'), SpeciesCatalog.fallback);
  });
}
