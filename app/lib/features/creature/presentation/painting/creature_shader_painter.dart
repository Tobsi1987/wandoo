import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:wandoo/features/creature/domain/creature.dart';
import 'package:wandoo/features/creature/presentation/painting/creature_shader_uniforms.dart';
import 'package:wandoo/features/world/world.dart';

/// Malt das Wesen mit `shaders/creature.frag`.
class CreatureShaderPainter extends CustomPainter {
  CreatureShaderPainter(
    this.shader,
    this.creature,
    this.time, {
    required this.sleepy,
    required this.silhouette,
    required this.world,
    this.awake = false,
  }) : super(repaint: time);

  final FragmentShader shader;
  final Creature creature;
  final bool sleepy;
  final bool silhouette;
  final WorldState? world;

  /// Wach, auch nachts (zum Beispiel beim Laufen).
  final bool awake;
  final ValueListenable<double> time;

  @override
  void paint(Canvas canvas, Size size) {
    setCreatureUniforms(
      shader,
      size: size,
      time: time.value,
      creature: creature,
      sleepy: sleepy,
      silhouette: silhouette,
      world: world,
      awake: awake,
    );
    canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(CreatureShaderPainter old) =>
      old.creature != creature ||
      old.sleepy != sleepy ||
      old.silhouette != silhouette ||
      old.world != world ||
      old.awake != awake;
}
