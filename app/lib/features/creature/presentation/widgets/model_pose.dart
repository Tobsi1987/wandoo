import 'dart:math' as math;

import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart' as vm;

/// Ganzkörper-Bewegung des Modells: wippen und schauen, im Schlaf zur Seite
/// kippen. [turn] ist eine zusätzliche Drehung um die Hochachse.
void poseBody(
  Node pivot,
  double t, {
  required bool grownUp,
  required bool sleepy,
  required double turn,
}) {
  final scale = grownUp ? 1.0 : 0.8;
  final bob = sleepy ? 0.008 * math.sin(t * 1.4) : 0.02 * math.sin(t * 2.4);
  final look = sleepy ? 0.0 : 0.3 * math.sin(t * 0.55);
  final tilt = sleepy ? 0.16 : 0.04 * math.sin(t * 1.2);
  pivot
    ..scale = vm.Vector3.all(scale)
    ..position = vm.Vector3(0, bob.abs() * scale, 0)
    ..rotation =
        vm.Quaternion.axisAngle(vm.Vector3(0, 1, 0), look + turn) *
        vm.Quaternion.axisAngle(vm.Vector3(0, 0, 1), tilt);
}
