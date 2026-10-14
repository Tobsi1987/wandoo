import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:wandoo/features/creature/presentation/widgets/celebration_pose.dart';
import 'package:wandoo/features/creature/presentation/widgets/creature_spin.dart';

/// Stellt [child] so hin, wie [pose] es verlangt: springen, stauchen,
/// drehen. Mit [model] dreht sich das 3D-Modell selbst, sonst klappt die
/// Figur nur um.
Widget posedFigure({
  required CelebrationPose pose,
  required double size,
  required bool model,
  required Widget child,
}) {
  final flat = model ? 1.0 : math.cos(pose.spin);
  final stretch = pose.stretch;
  return Transform.translate(
    offset: Offset(0, -size * pose.lift),
    child: Transform.rotate(
      angle: pose.shake + pose.sway,
      alignment: Alignment.bottomCenter,
      child: Transform.scale(
        scaleX: pose.scale * flat * (1 + 0.1 * pose.squash - 0.04 * stretch),
        scaleY: pose.scale * (1 - 0.1 * pose.squash + 0.06 * stretch),
        alignment: Alignment.bottomCenter,
        child: CreatureSpin(turns: pose.spin, child: child),
      ),
    ),
  );
}
