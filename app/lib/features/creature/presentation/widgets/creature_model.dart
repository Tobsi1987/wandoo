import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart' as vm;
import 'package:wandoo/features/creature/domain/outfit.dart';
import 'package:wandoo/features/creature/presentation/widgets/creature_spin.dart';
import 'package:wandoo/features/creature/presentation/widgets/model_accessories.dart';
import 'package:wandoo/features/creature/presentation/widgets/model_anchors.dart';
import 'package:wandoo/features/creature/presentation/widgets/model_eyes.dart';
import 'package:wandoo/features/creature/presentation/widgets/model_overlays.dart';

/// Ein 3D-Modell (.glb) des Wesens, das als Ganzes atmet, schwankt und
/// schläft. Das Aussehen bleibt genau so, wie es aus Meshy kommt.
///
/// Bis das Modell geladen ist, oder wenn das Gerät kein 3D kann, steht
/// [fallback] an seiner Stelle.
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

  static final Future<bool> _ready = Scene.initializeStaticResources().then(
    (_) => true,
    onError: (Object _) => false,
  );
  static final _models = <String, Future<Node?>>{};

  /// Lädt das Modell vorab, damit es beim ersten Zeigen sofort da ist.
  static Future<void> preload(String asset) => _load(asset);

  static Future<Node?> _load(String asset) => _models[asset] ??= _ready.then(
    (ok) => ok
        ? Node.fromGlbAsset(asset).then<Node?>((n) => n, onError: (_) => null)
        : null,
  );

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

  /// Zusätzliche Drehung von außen, siehe [CreatureSpin].
  double _spin = 0;

  @override
  void initState() {
    super.initState();
    _scene
      ..exposure = 1.35
      ..add(_pivot);
    unawaited(CreatureModel._load(widget.asset).then(_show));
  }

  void _show(Node? model) {
    if (!mounted || model == null) return;
    _pivot.add(model.clone());
    _dress();
    _pose(0);
    setState(() => _loaded = true);
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
          vm.Quaternion.axisAngle(vm.Vector3(0, 1, 0), look + _spin) *
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
      unawaited(CreatureModel._load(widget.asset).then(_show));
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spin = CreatureSpin.of(context);
    if (spin != _spin) {
      _spin = spin;
      if (_loaded) _pose(_time.value);
    }
    if (!_loaded) return widget.fallback;
    return SizedBox.square(
      dimension: widget.size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const CustomPaint(painter: ModelShadow()),
          SceneView(
            _scene,
            autoTick: widget.animate,
            maxFrameRate: 30,
            camera: PerspectiveCamera(
              position: vm.Vector3(0, 0.6, -1.75),
              target: vm.Vector3(0, 0.46, 0),
            ),
            onTick: (elapsed, _) {
              if (!widget.animate) return;
              _time.value = elapsed.inMicroseconds / 1e6;
              _pose(_time.value);
            },
          ),
          if (widget.night)
            IgnorePointer(child: CustomPaint(painter: Fireflies(_time))),
        ],
      ),
    );
  }
}
