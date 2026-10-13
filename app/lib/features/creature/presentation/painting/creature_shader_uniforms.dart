import 'dart:ui';

import 'package:wandoo/features/creature/domain/creature.dart';
import 'package:wandoo/features/creature/domain/growth_stage.dart';
import 'package:wandoo/features/creature/domain/species_catalog.dart';
import 'package:wandoo/features/creature/domain/trait.dart';
import 'package:wandoo/features/creature/presentation/painting/body_geometry.dart';
import 'package:wandoo/features/creature/presentation/species_looks.dart';

/// Überträgt das Wesen in die Uniforms von `shaders/creature.frag`.
///
/// Die Reihenfolge muss zu den `uniform`-Zeilen im Shader passen.
void setCreatureUniforms(
  FragmentShader shader, {
  required Size size,
  required double time,
  required Creature creature,
  required bool sleepy,
}) {
  final egg = creature.stage == GrowthStage.egg;
  final accent = egg ? creature.dominantTrait : creature.accentTrait;
  final color = accentColor(accent);
  final values = <double>[
    size.width,
    size.height,
    time,
    creature.stage.index.toDouble(),
    speciesLooks[SpeciesCatalog.byId(creature.speciesId).id]!.placeholder
        .toDouble(),
    color.r,
    color.g,
    color.b,
    if (accent == null) 0 else _level(creature, accent),
    if (sleepy) 1 else 0,
    if (_nearlyHatched(creature)) 1 else 0,
  ];
  for (var i = 0; i < values.length; i++) {
    shader.setFloat(i, values[i]);
  }
}

/// Farbe, mit der eine Umgebung Muster ins Fell oder aufs Ei malt.
Color accentColor(Trait? trait) => switch (trait) {
  null => const Color(0xFFB9A6E0),
  Trait.moss => const Color(0xFF7DBF5E),
  Trait.fins => const Color(0xFF5FA8E0),
  Trait.lanterns => const Color(0xFFF2C14E),
  Trait.wheatEars => const Color(0xFFE0A85A),
};

double _level(Creature c, Trait trait) =>
    traitLevel(c.traitPoints[trait] ?? 0).toDouble();

bool _nearlyHatched(Creature c) =>
    c.stage == GrowthStage.egg && c.food * 2 >= GrowthStage.juvenile.foodNeeded;
