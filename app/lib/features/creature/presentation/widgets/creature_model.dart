import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart' as vm;
import 'package:wandoo/features/creature/domain/outfit.dart';
import 'package:wandoo/features/creature/presentation/widgets/creature_spin.dart';
import 'package:wandoo/features/creature/presentation/widgets/drag_turn.dart';
import 'package:wandoo/features/creature/presentation/widgets/model_accessories.dart';
import 'package:wandoo/features/creature/presentation/widgets/model_anchors.dart';
import 'package:wandoo/features/creature/presentation/widgets/model_eyes.dart';
import 'package:wandoo/features/creature/presentation/widgets/model_loader.dart';
import 'package:wandoo/features/creature/presentation/widgets/model_stage.dart';

/// Ein 3D-Modell (.glb) des Wesens, das als Ganzes atmet, schwankt und
/// schläft. Das Aussehen bleibt genau so, wie es aus Meshy kommt.
///
/// Bis das Modell geladen ist, bleibt der Platz leer. Kann das Gerät kein
/// 3D, steht [fallback] an seiner Stelle. Wischen dreht das Wesen.
class CreatureModel extends StatefulWidget {
  const CreatureModel({
    required this.asset,
    required this.size,
    required this.fallback,
    this.sleepy = false,
    this.grownUp = true,
    this.animate = true,
    this.night = false,
    this.anchors = ModelAnchors.fallback,
    this.hat,
    this.neck,
    this.eyes,
    this.eyesClosed = false,
    super.key,
  });

  /// Vorbereitetes Modell: Füße auf y = 0, 1 Einheit hoch.
  final String asset;
  final double size;
  final Widget fallback;
  final bool sleepy;

  /// Jungtiere sind etwas kleiner.
  final bool grownUp;
  final bool animate;

  /// Nachts schwirren Glühwürmchen um das Wesen.
  final bool night;

  /// Wo [hat] und [neck] auf diesem Modell sitzen.
  final ModelAnchors anchors;
  final CreatureHat? hat;
  final CreatureNeck? neck;

  /// Wo die Augen sitzen; nur damit kann es sie im Schlaf schließen.
  final EyeSpot? eyes;
  final bool eyesClosed;

  /// Lädt das Modell vorab, damit es beim ersten Zeigen sofort da ist.
  static Future<void> preload(String asset) => ModelLoader.load(asset);

  @override
  State<CreatureModel> createState() => _CreatureModelState();
}

class _CreatureModelState extends State<CreatureModel> {
  final _scene = Scene();
  final _pivot = Node();
  final _time = ValueNotifier<double>(0);
  Node? _outfit;
  Node? _lids;
  bool _loaded = false;
  bool _failed = false;

  /// Vom Wischen, siehe [DragTurn].
  final _drag = ValueNotifier<double>(0);

  /// Zusätzliche Drehung von außen, siehe [CreatureSpin].
  double _spin = 0;

  @override
  void initState() {
    super.initState();
    _scene
      ..exposure = 1.35
      ..add(_pivot);
    _drag.addListener(() => _pose(_time.value));
    _start();
  }

  /// Schon geladene Modelle sofort zeigen, ohne leeres Bild dazwischen.
  void _start() {
    final asset = widget.asset;
    if (ModelLoader.isDone(asset)) {
      _add(ModelLoader.ready(asset));
    } else {
      unawaited(ModelLoader.load(asset).then(_show));
    }
  }

  void _show(Node? model) {
    if (!mounted) return;
    setState(() => _add(model));
  }

  void _add(Node? model) {
    _failed = model == null;
    if (model == null) return;
    _pivot.add(model.clone());
    _dress();
    _pose(0);
    _loaded = true;
  }

  /// Hut, Halsschmuck und Schlaf-Lider neu anziehen.
  void _dress() {
    _outfit?.detach();
    final w = widget;
    _outfit = w.hat == null && w.neck == null
        ? null
        : modelAccessories(w.anchors, w.hat, w.neck);
    if (_outfit case final outfit?) _pivot.add(outfit);
    _lids?.detach();
    _lids = switch (w.eyes) {
      final eyes? when w.eyesClosed => modelEyelids(eyes),
      _ => null,
    };
    if (_lids case final lids?) _pivot.add(lids);
  }

  /// Ganzkörper-Bewegung: wippen und schauen, im Schlaf zur Seite kippen.
  void _pose(double t) {
    final scale = widget.grownUp ? 1.0 : 0.8;
    final sleepy = widget.sleepy;
    final bob = sleepy ? 0.008 * math.sin(t * 1.4) : 0.02 * math.sin(t * 2.4);
    final look = sleepy ? 0.0 : 0.3 * math.sin(t * 0.55);
    final tilt = sleepy ? 0.16 : 0.04 * math.sin(t * 1.2);
    _pivot
      ..scale = vm.Vector3.all(scale)
      ..position = vm.Vector3(0, bob.abs() * scale, 0)
      ..rotation =
          vm.Quaternion.axisAngle(
            vm.Vector3(0, 1, 0),
            look + _spin + _drag.value,
          ) *
          vm.Quaternion.axisAngle(vm.Vector3(0, 0, 1), tilt);
  }

  @override
  void didUpdateWidget(CreatureModel old) {
    super.didUpdateWidget(old);
    if (old.asset != widget.asset) {
      _pivot.removeAll();
      _outfit = null;
      _lids = null;
      _loaded = false;
      _start();
    } else if (_loaded) {
      if (old.hat != widget.hat ||
          old.neck != widget.neck ||
          old.eyesClosed != widget.eyesClosed) {
        _dress();
      }
      // Mit der aktuellen Zeit, sonst springt die Figur bei jedem Neuaufbau
      // kurz in die Ausgangshaltung (sieht beim Laufen wie Zittern aus).
      _pose(_time.value);
    }
  }

  @override
  void dispose() {
    _time.dispose();
    _drag.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spin = CreatureSpin.of(context);
    if (spin != _spin) {
      _spin = spin;
      if (_loaded) _pose(_time.value);
    }
    if (_failed) return widget.fallback;
    if (!_loaded) return SizedBox.square(dimension: widget.size);
    final view = ModelStage(
      scene: _scene,
      size: widget.size,
      animate: widget.animate,
      night: widget.night,
      time: _time,
      onTime: _pose,
    );
    if (!widget.animate) return view;
    return DragTurn(angle: _drag, size: widget.size, child: view);
  }
}
