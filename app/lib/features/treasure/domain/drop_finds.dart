import 'dart:math';

import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/treasure/domain/find.dart';

/// Würfelt aus, was auf den neuen Abschnitten eines Gangs lag.
///
/// Jeder neue Abschnitt hat eine Chance auf das Fundstück seiner Umgebung
/// und eine kleine auf einen Sternsplitter. Bekannte Wege geben nichts.
class DropFinds {
  const DropFinds({
    this.chance = 0.2,
    this.starChance = 0.01,
    this.maxPerWalk = 6,
  });

  final double chance;
  final double starChance;
  final int maxPerWalk;

  List<Find> call(Map<EnvironmentType, int> newSegments, Random random) {
    final found = <Find>[];
    newSegments.forEach((type, count) {
      final local = Find.forEnvironment(type);
      for (var i = 0; i < count; i++) {
        if (random.nextDouble() < starChance) {
          found.add(Find.starShard);
        } else if (local != null && random.nextDouble() < chance) {
          found.add(local);
        }
      }
    });
    return found.take(maxPerWalk).toList();
  }
}
