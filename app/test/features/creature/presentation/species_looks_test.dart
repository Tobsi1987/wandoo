import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/creature/presentation/species_looks.dart';

void main() {
  test('jede Art im Katalog hat ein Aussehen', () {
    for (final species in SpeciesCatalog.all) {
      expect(speciesLooks, contains(species.id), reason: species.name);
    }
  });

  test('jedes eingetragene Modell liegt in den Assets und ist klein', () {
    for (final look in speciesLooks.values) {
      final asset = look.modelAsset;
      if (asset == null) continue;
      final file = File(asset);
      expect(file.existsSync(), isTrue, reason: asset);
      expect(file.lengthSync(), lessThan(3 * 1024 * 1024), reason: asset);
    }
  });
}
