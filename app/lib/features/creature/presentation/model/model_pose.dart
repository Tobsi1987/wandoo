import 'dart:math' as math;

import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart' as vm;

/// Ganzkörper-Bewegung des Modells: sanft atmen und schauen, im Schlaf zur
/// Seite kippen. Beim Gehen bewegt das Rig den Körper selbst, dann bleibt
/// er hier ruhig (sonst sähe es wie Hüpfen aus). [turn] ist eine
/// zusätzliche Drehung um die Hochachse, [scale] die Größe (1 = ausgewachsen).
void poseBody(
  Node pivot,
  double t, {
  required double scale,
  required bool sleepy,
  required double turn,
  bool walking = false,
}) {
  final breath = (1 - math.cos(t * (sleepy ? 1.2 : 1.6))) / 2;
  final bob = walking ? 0.0 : (sleepy ? 0.004 : 0.006) * breath;
  final look = sleepy ? 0.0 : (walking ? 0.12 : 0.3) * math.sin(t * 0.55);
  final tilt = sleepy ? 0.16 : (walking ? 0.0 : 0.03 * math.sin(t * 0.8));
  pivot
    ..scale = vm.Vector3.all(scale)
    ..position = vm.Vector3(0, bob * scale, 0)
    ..rotation =
        vm.Quaternion.axisAngle(vm.Vector3(0, 1, 0), look + turn) *
        vm.Quaternion.axisAngle(vm.Vector3(0, 0, 1), tilt);
}
