import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart' as vm;
import 'package:wandoo/features/creature/domain/creature.dart';
import 'package:wandoo/features/creature/domain/growth_stage.dart';
import 'package:wandoo/features/creature/presentation/model/model_loader.dart';
import 'package:wandoo/features/creature/presentation/model/model_stage.dart';
import 'package:wandoo/features/creature/presentation/species_looks.dart';
import 'package:wandoo/features/world/world.dart';

/// Das Ei als 3D-Modell (Plüsch-Ei aus Meshy), im selben Licht wie die
/// Wesen. Es wackelt sanft, kurz vor dem Schlüpfen ([crack]) schneller.
class EggModel extends StatefulWidget {
  const EggModel({
    required this.size,
    this.crack = false,
    this.animate = true,
    this.night = false,
    super.key,
  });

  /// Das Ei von [egg]: wackelt stärker, wenn es bald schlüpft.
  factory EggModel.of(
    Creature egg, {
    required double size,
    WorldState? world,
    bool animate = true,
  }) => EggModel(
    size: size,
    crack: egg.food * 2 >= GrowthStage.juvenile.foodNeeded,
    animate: animate,
    night: world?.night ?? false,
  );

  final double size;
  final bool crack;
  final bool animate;
  final bool night;

  /// Das Modell, aufbereitet mit `tool/prepare_model.mjs` (1 hoch).
  static final String asset = modelAssetOf('egg');

  /// Wie hoch das Ei neben den Wesen steht (ein Wesen ist 1 hoch).
  static const height = 0.62;

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
    final asset = EggModel.asset;
    if (ModelLoader.isDone(asset)) {
      _add(ModelLoader.ready(asset));
    } else {
      unawaited(ModelLoader.load(asset).then((m) => mounted ? _add(m) : null));
    }
  }

  void _add(Node? model) {
    if (model == null) return;
    _pivot
      ..add(model.clone())
      ..scale = vm.Vector3.all(EggModel.height);
    _wobble(_time.value);
    setState(() {});
  }

  /// Kippt um den Fußpunkt hin und her.
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
