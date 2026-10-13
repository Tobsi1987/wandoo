import 'dart:ui';

import 'package:wandoo/features/creature/domain/creature.dart';
import 'package:wandoo/features/creature/domain/growth_stage.dart';
import 'package:wandoo/features/creature/domain/trait.dart';
import 'package:wandoo/features/creature/presentation/painting/body_geometry.dart';
import 'package:wandoo/features/creature/presentation/painting/creature_palette.dart';

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
  final body = CreaturePalette.body(creature.dominantTrait);
  final values = <double>[
    size.width,
    size.height,
    time,
    creature.stage.index.toDouble(),
    body.r,
    body.g,
    body.b,
    for (final trait in Trait.values) _level(creature, trait),
    if (sleepy) 1 else 0,
    if (_nearlyHatched(creature)) 1 else 0,
  ];
  for (var i = 0; i < values.length; i++) {
    shader.setFloat(i, values[i]);
  }
}

double _level(Creature c, Trait trait) =>
    traitLevel(c.traitPoints[trait] ?? 0).toDouble();

bool _nearlyHatched(Creature c) =>
    c.stage == GrowthStage.egg && c.food * 2 >= GrowthStage.juvenile.foodNeeded;
