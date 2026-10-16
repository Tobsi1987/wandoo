import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart' as vm;
import 'package:wandoo/features/bath/presentation/widgets/tub_water.dart';

/// Die Badewanne (3D-Modell) in zwei Ebenen: [Tub.back] liegt hinter dem
/// Wesen (ganze Wanne und Wasserfläche), [Tub.front] davor (nur die
/// vordere Wand unter dem Rand, dazu Wasser und Schaum). So sitzt das
/// Wesen wirklich im Wasser.
class Tub extends StatefulWidget {
  const Tub.back({required this.width, super.key}) : front = false;
  const Tub.front({required this.width, super.key}) : front = true;

  final double width;
  final bool front;

  /// Höhe im Verhältnis zur Breite.
  static const ratio = 0.62;

  /// Wo der vordere Rand in der Mitte liegt, als Anteil der Höhe.
  static const double rimAt = TubWater.rimAt;

  static const asset = 'assets/bath/tub.glb';

  static final Future<Node?> _model = Scene.initializeStaticResources()
      .then((_) => Node.fromGlbAsset(asset))
      .then<Node?>((n) => n, onError: (Object _) => null);

  @override
  State<Tub> createState() => _TubState();
}

class _TubState extends State<Tub> {
  Scene? _scene;

  @override
  void initState() {
    super.initState();
    Tub._model.then((node) {
      if (!mounted || node == null) return;
      setState(
        () => _scene = Scene()
          ..exposure = 1.5
          ..add(node.clone()),
      );
    }).ignore();
  }

  @override
  Widget build(BuildContext context) {
    final size = Size(widget.width, widget.width * Tub.ratio);
    final scene = _scene;
    final model = scene == null
        ? const SizedBox.shrink()
        : SceneView(scene, autoTick: false, camera: _camera);
    return SizedBox.fromSize(
      size: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (widget.front)
            ClipRect(clipper: const _BelowRim(), child: model)
          else
            model,
          CustomPaint(painter: TubWater(front: widget.front)),
        ],
      ),
    );
  }

  /// Leicht von oben, die ganze Wanne im Bild.
  static final PerspectiveCamera _camera = () {
    const pitch = 0.42;
    const distance = 3.0;
    const look = 0.24;
    return PerspectiveCamera(
      position: vm.Vector3(
        0,
        look + distance * math.sin(pitch),
        distance * math.cos(pitch),
      ),
      target: vm.Vector3(0, look, 0),
      fovRadiansY: 2 * math.atan(0.34 / distance),
    );
  }();
}

/// Nur was unter dem vorderen Rand liegt: die Außenwand der Wanne.
class _BelowRim extends CustomClipper<Rect> {
  const _BelowRim();

  @override
  Rect getClip(Size size) =>
      Rect.fromLTRB(0, size.height * Tub.rimAt, size.width, size.height);

  @override
  bool shouldReclip(_BelowRim old) => false;
}
