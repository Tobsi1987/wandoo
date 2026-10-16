import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:vector_math/vector_math.dart' as vm;
import 'package:wandoo/features/creature/presentation/egg/egg_colors.dart';

void main() {
  const accent = Color(0xFF7DBF5E);

  test('jedes Muster gibt gültige Farben', () {
    for (var theme = 0; theme <= 7; theme++) {
      for (final q in [vm.Vector3(0, 1, 0), vm.Vector3(1, 0, 0)]) {
        final c = eggColor(q, theme: theme, accent: accent);
        for (final v in [c.x, c.y, c.z]) {
          expect(v, inInclusiveRange(0, 1));
        }
      }
    }
  });

  test('kurz vor dem Schlüpfen zeigt die Schale einen dunklen Riss', () {
    final q = vm.Vector3(0, 0.11, 0.994);
    final whole = eggColor(q, theme: 0, accent: accent);
    final cracked = eggColor(q, theme: 0, accent: accent, crack: true);
    expect(cracked.length, lessThan(whole.length));
  });
}
