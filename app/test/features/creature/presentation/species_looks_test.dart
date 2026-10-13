import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/creature/presentation/species_looks.dart';

void main() {
  test('jede Art im Katalog hat ein Aussehen', () {
    for (final species in SpeciesCatalog.all) {
      expect(speciesLooks, contains(species.id), reason: species.name);
    }
  });
}
