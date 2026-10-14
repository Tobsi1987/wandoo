import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/creature/domain/species_catalog.dart';
import 'package:wandoo/features/creature/presentation/marks/mark_surface.dart';

void main() {
  test('jede Art hat Stellen für die Spuren der Welt', () {
    MarkSurface.read(File(MarkSurface.asset).readAsStringSync());
    for (final species in SpeciesCatalog.all) {
      final surface = MarkSurface.of(species.id);
      expect(surface, isNotNull, reason: species.id);
      expect(surface!.top.length, greaterThan(20), reason: species.id);
      expect(surface.back.length, greaterThan(20), reason: species.id);
      expect(surface.shoulders, hasLength(2), reason: species.id);
      // Oben auf dem Kopf zeigt die Haut nach oben.
      expect(surface.top.first.normal.y, greaterThan(0), reason: species.id);
    }
  });
}
