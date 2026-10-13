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

  /// Bewegt das Wesen zur neuen Zeit.
  final void Function(double seconds) onTime;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const CustomPaint(painter: ModelShadow()),
          SceneView(
            scene,
            autoTick: animate,
            maxFrameRate: 30,
            camera: PerspectiveCamera(
              position: vm.Vector3(0, 0.6, -1.75),
              target: vm.Vector3(0, 0.46, 0),
            ),
            onTick: (elapsed, _) {
              if (!animate) return;
              time.value = elapsed.inMicroseconds / 1e6;
              onTime(time.value);
            },
          ),
          if (night)
            IgnorePointer(child: CustomPaint(painter: Fireflies(time))),
          if (asleep) IgnorePointer(child: CustomPaint(painter: SleepZs(time))),
        ],
      ),
    );
  }
}
