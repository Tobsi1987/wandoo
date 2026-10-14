import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_scene/scene.dart';
import 'package:wandoo/features/creature/domain/outfit.dart';
import 'package:wandoo/features/creature/presentation/widgets/creature_spin.dart';
import 'package:wandoo/features/creature/presentation/widgets/drag_turn.dart';
import 'package:wandoo/features/creature/presentation/widgets/model_anchors.dart';
import 'package:wandoo/features/creature/presentation/widgets/model_dress.dart';
import 'package:wandoo/features/creature/presentation/widgets/model_eyes.dart';
import 'package:wandoo/features/creature/presentation/widgets/model_loader.dart';
import 'package:wandoo/features/creature/presentation/widgets/model_motions.dart';
import 'package:wandoo/features/creature/presentation/widgets/model_pose.dart';
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
    this.outfit = const Outfit(),
    this.eyes,
    this.eyesClosed = false,
    this.walking = false,
    super.key,
  });

  /// Vorbereitetes Modell: Füße auf y = 0, 1 Einheit hoch; bringt es
  /// Animationen mit (siehe [Motion]), spielt es sie ab.
  final String asset;
  final double size;
  final Widget fallback;
  final bool sleepy;

  /// Jungtiere sind etwas kleiner.
  final bool grownUp;
  final bool animate;

  /// Nachts schwirren Glühwürmchen um das Wesen.
  final bool night;

  /// Wo Hut, Halsschmuck und Schirm auf diesem Modell sitzen.
  final ModelAnchors anchors;
  final Outfit outfit;

  /// Wo die Augen sitzen; nur damit kann es sie im Schlaf schließen.
  final EyeSpot? eyes;
  final bool eyesClosed;

  /// Läuft gerade mit (Geh-Animation bei geriggten Modellen).
  final bool walking;

  @override
  State<CreatureModel> createState() => _CreatureModelState();
}

class _CreatureModelState extends State<CreatureModel> {
  final _scene = Scene();
  final _pivot = Node();
  final _time = ValueNotifier<double>(0);
  final _dress = ModelDress();
  ModelMotions? _motions;
  bool _loaded = false;
  bool _failed = false;

  /// Vom Wischen, siehe [DragTurn].
  final _drag = ValueNotifier<double>(0);

  /// Zusätzliche Drehung von außen, siehe [CreatureSpin].
  double _spin = 0;

  /// Bewegung von außen, siehe [CreatureMotion].
  Motion? _motion;

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
      unawaited(ModelLoader.load(asset).then(_loadedLater));
    }
  }

  void _loadedLater(Node? m) => mounted ? setState(() => _add(m)) : null;

  void _add(Node? model) {
    _failed = model == null;
    if (model == null) return;
    final copy = model.clone();
    _pivot.add(copy);
    _motions = ModelMotions(copy);
    _wear();
    _pose(0);
    _loaded = true;
  }

  void _wear() {
    final w = widget;
    _dress.apply(
      _pivot,
      anchors: w.anchors,
      outfit: w.outfit,
      eyes: w.eyes,
      eyesClosed: w.eyesClosed,
    );
  }

  /// Jedes Bild: Körper bewegen und die passende Rig-Animation zeigen.
  void _tick(double t, double delta) {
    _pose(t);
    final w = widget;
    final own = w.sleepy ? Motion.sleep : (w.walking ? Motion.walk : null);
    _motions?.show(_motion ?? own ?? Motion.idle, delta);
  }

  void _pose(double t) => poseBody(
    _pivot,
    t,
    grownUp: widget.grownUp,
    sleepy: widget.sleepy,
    turn: _spin + _drag.value,
  );

  @override
  void didUpdateWidget(CreatureModel old) {
    super.didUpdateWidget(old);
    if (old.asset != widget.asset) {
      _pivot.removeAll();
      _dress.forget();
      _motions = null;
      _loaded = false;
      _start();
    } else if (_loaded) {
      if (old.outfit != widget.outfit || old.eyesClosed != widget.eyesClosed) {
        _wear();
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
    _motion = CreatureMotion.of(context);
    if (_failed) return widget.fallback;
    if (!_loaded) return SizedBox.square(dimension: widget.size);
    final view = ModelStage(
      scene: _scene,
      size: widget.size,
      animate: widget.animate,
      night: widget.night,
      asleep: widget.eyesClosed && widget.eyes != null,
      time: _time,
      onTime: _tick,
    );
    if (!widget.animate) return view;
    return DragTurn(angle: _drag, size: widget.size, child: view);
  }
}
