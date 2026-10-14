import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart' as vm;
import 'package:wandoo/features/creature/presentation/widgets/model_overlays.dart';
import 'package:wandoo/features/creature/presentation/widgets/sleep_zs.dart';

/// Die Bühne für ein 3D-Wesen: Schatten, Kamera und nachts Glühwürmchen.
class ModelStage extends StatelessWidget {
  const ModelStage({
    required this.scene,
    required this.size,
    required this.animate,
    required this.night,
    required this.time,
    required this.onTime,
    this.asleep = false,
    super.key,
  });

  final Scene scene;
  final double size;
  final bool animate;
  final bool night;

  /// Augen zu: „z“ steigen über dem Kopf auf.
  final bool asleep;

  /// Sekunden seit dem Start; wird bei jedem Bild weitergezählt.
  final ValueNotifier<double> time;

  /// Bewegt das Wesen zur neuen Zeit; dazu die Sekunden seit dem letzten
  /// Bild.
  final void Function(double seconds, double delta) onTime;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const CustomPaint(painter: ModelShadow()),
          // Oben etwas Luft, damit hohe Hüte nicht abgeschnitten werden:
          // Die Szene ist höher als das Quadrat und ragt oben heraus.
          OverflowBox(
            alignment: Alignment.bottomCenter,
            maxHeight: size * _headroom,
            child: SceneView(
              scene,
              autoTick: animate,
              maxFrameRate: 30,
              camera: _camera,
              onTick: (elapsed, delta) {
                if (!animate) return;
                time.value = elapsed.inMicroseconds / 1e6;
                onTime(time.value, delta);
              },
            ),
          ),
          if (night)
            IgnorePointer(child: CustomPaint(painter: Fireflies(time))),
          if (asleep) IgnorePointer(child: CustomPaint(painter: SleepZs(time))),
        ],
      ),
    );
  }

  static const _headroom = 1.3;

  /// Wie die alte Kamera fürs Quadrat, nur mit größerem Blickwinkel und
  /// etwas angehoben, damit das Wesen gleich groß an derselben Stelle steht.
  static final PerspectiveCamera _camera = () {
    final half = math.tan(22.5 * math.pi / 180);
    final lift = (_headroom - 1) / 2 * 2 * 1.756 * half;
    return PerspectiveCamera(
      position: vm.Vector3(0, 0.6 + lift, -1.75),
      target: vm.Vector3(0, 0.46 + lift, 0),
      fovRadiansY: 2 * math.atan(_headroom * half),
    );
  }();
}
