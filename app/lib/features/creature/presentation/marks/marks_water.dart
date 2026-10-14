import 'dart:math' as math;

import 'package:vector_math/vector_math.dart' as vm;
import 'package:wandoo/features/creature/presentation/marks/mark_mesh.dart';
import 'package:wandoo/features/creature/presentation/marks/mark_spot.dart';
import 'package:wandoo/features/creature/presentation/marks/mark_surface.dart';

// Wasser: glänzende türkise Schuppen auf dem Rücken, später auch an den
// Schultern, ganz zum Schluss ein Seerosen-Hut.

const _scales = [0x5bbfd6, 0x7fd3e2, 0x46a9c6];

void waterMarks(MarkSpot s, MarkMesh plain, MarkMesh shiny) {
  for (final p in s.grown(s.surface.back, const [0.35, 0.7, 1])) {
    _scale(s, shiny, p, 0.03);
  }
  if (s.level >= 2) {
    for (final p in s.surface.shoulders) {
      for (var i = 0; i < 3; i++) {
        final a = i * 2.1;
        final at = s.beside(p, math.sin(a) * 0.02, math.cos(a) * 0.02);
        _scale(s, shiny, SurfacePoint(at, p.normal), 0.02);
      }
    }
  }
  if (s.level == 3 && s.headFree) _lily(s, plain);
}

void _scale(MarkSpot s, MarkMesh mesh, SurfacePoint p, double size) =>
    mesh.blob(
      p.at + p.normal * 0.002,
      along(p.normal, s.between(0, 6.3)),
      vm.Vector3(size, size * 0.24, size * 0.85),
      _scales[s.random.nextInt(_scales.length)],
    );

/// Ein Seerosenblatt als Hut mit einer rosa Blüte darauf.
void _lily(MarkSpot s, MarkMesh mesh) {
  final r = s.anchors.headRadius;
  final base = s.crown + vm.Vector3(0, 0.02, 0);
  mesh.blob(
    base,
    vm.Quaternion.axisAngle(vm.Vector3(0, 0, 1), 0.12),
    vm.Vector3(0.7 * r, 0.06 * r, 0.7 * r),
    0x5fae5a,
  );
  for (final (ring, count, rgb) in [(0, 7, 0xf796b6), (1, 6, 0xffc2d6)]) {
    for (var i = 0; i < count; i++) {
      final a = i / count * 2 * math.pi + ring * 0.45;
      final spread = 0.55 - ring * 0.3;
      final dir = vm.Vector3(math.sin(a) * spread, 1, math.cos(a) * spread)
        ..normalize();
      mesh.blob(
        base + dir * (0.2 * r),
        along(dir),
        vm.Vector3(0.1 * r, 0.22 * r, 0.05 * r),
        rgb,
      );
    }
  }
  mesh.ball(base + vm.Vector3(0, 0.16 * r, 0), 0.07 * r, 0xf5c623);
}
