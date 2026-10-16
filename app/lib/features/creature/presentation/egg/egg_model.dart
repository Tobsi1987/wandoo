import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart' as vm;
import 'package:wandoo/features/creature/domain/creature.dart';
import 'package:wandoo/features/creature/domain/growth_stage.dart';
import 'package:wandoo/features/creature/presentation/egg/egg_mesh.dart';
import 'package:wandoo/features/creature/presentation/model/model_stage.dart';
import 'package:wandoo/features/creature/presentation/painting/creature_shader_uniforms.dart';
import 'package:wandoo/features/world/world.dart';

/// Das Ei in echtem 3D, im selben Licht wie die Wesen. Es wackelt sanft,
/// kurz vor dem Schlüpfen ([crack]) schneller und mit Riss.
class EggModel extends StatefulWidget {
  const EggModel({
    required this.size,
    required this.theme,
    required this.accent,
    this.crack = false,
    this.animate = true,
    this.night = false,
    super.key,
  });

  /// Das Ei von [egg]: Muster nach Jahreszeit oder Fest aus [world],
  /// Tupfen in der Farbe der stärksten Spur, Riss kurz vor dem Schlüpfen.
  factory EggModel.of(
    Creature egg, {
    required double size,
    WorldState? world,
    bool animate = true,
  }) => EggModel(
    size: size,
    theme: (world?.eggTheme.index ?? -1) + 1,
    accent: accentColor(egg.dominantTrait),
    crack: egg.food * 2 >= GrowthStage.juvenile.foodNeeded,
    animate: animate,
    night: world?.night ?? false,
  );

  final double size;

  /// 0 schlicht, sonst `EggTheme`-Index + 1.
  final int theme;

  /// Farbe der Tupfen auf dem schlichten Ei.
  final Color accent;
  final bool crack;
  final bool animate;
  final bool night;

  @override
  State<EggModel> createState() => _EggModelState();
}

class _EggModelState extends State<EggModel> {
  final _scene = Scene();
  final _pivot = Node();
  final _time = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();
    _scene
      ..exposure = 1.35
      ..add(_pivot);
    _build();
  }

  @override
  void didUpdateWidget(EggModel old) {
    super.didUpdateWidget(old);
    if (old.theme != widget.theme ||
        old.accent != widget.accent ||
        old.crack != widget.crack) {
      _build();
    }
  }

  void _build() {
    _pivot
      ..removeAll()
      ..add(
        eggNode(
          theme: widget.theme,
          accent: widget.accent,
          crack: widget.crack,
        ),
      );
    _wobble(_time.value);
  }

  /// Kippt um den Fußpunkt hin und her, wie das alte Ei.
  void _wobble(double t) {
    final c = widget.crack ? 1.0 : 0.0;
    final angle = math.sin(t * (2 + 6 * c)) * (0.04 + 0.1 * c);
    _pivot.rotation = vm.Quaternion.axisAngle(vm.Vector3(0, 0, 1), angle);
  }

  @override
  void dispose() {
    _time.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ModelStage(
    scene: _scene,
    size: widget.size,
    animate: widget.animate,
    night: widget.night,
    time: _time,
    onTime: (t, _) => _wobble(t),
  );
}
