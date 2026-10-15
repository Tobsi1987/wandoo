import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/creature/presentation/model/model_anchors.dart';
import 'package:wandoo/features/creature/presentation/model/model_eyes.dart';
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
      // Geriggte Modelle tragen Knochengewichte, Glutling (Fell) ist ~4 MB.
      expect(file.lengthSync(), lessThan(4.5 * 1024 * 1024), reason: asset);
    }
  });

  test('jedes Modell weiß, wo Hut und Halsschmuck sitzen', () {
    for (final MapEntry(:key, :value) in speciesLooks.entries) {
      if (value.modelAsset == null) continue;
      expect(modelAnchors, contains(key), reason: key);
      final at = modelAnchors[key]!;
      expect(at.neckY, lessThan(at.hatY), reason: key);
      expect(at.hatY, inInclusiveRange(0.5, 1.0), reason: key);
    }
  });

  test('Stufenmodelle liegen bereit und kennen Hut und Augen', () {
    for (final stages in stageModels.values) {
      for (final id in stages.values) {
        expect(File(modelAssetOf(id)).existsSync(), isTrue, reason: id);
        expect(modelAnchors, contains(id), reason: id);
        expect(modelEyes, contains(id), reason: id);
      }
    }
  });

  test('ohne eigenes Stufenmodell zeigt eine Art das der Stufe davor', () {
    expect(stageModelOf('funkel', 1), (id: 'funkel', missing: 0));
    expect(stageModelOf('funkel', 2), (id: 'funkel2', missing: 0));
    expect(stageModelOf('funkel', 3), (id: 'funkel3', missing: 0));
    expect(stageModelOf('test', 3), (id: 'test', missing: 2));
    expect(stageModelOf('zapfi', 3), (id: 'zapfi', missing: 2));
  });
}
