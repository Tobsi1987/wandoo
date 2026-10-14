import 'dart:math' as math;

import 'package:vector_math/vector_math.dart' as vm;
import 'package:wandoo/features/creature/presentation/marks/mark_mesh.dart';
import 'package:wandoo/features/creature/presentation/marks/mark_spot.dart';
import 'package:wandoo/features/creature/presentation/marks/mark_surface.dart';

// Stadt: kleine warme Lichter wie Fenster am Abend, auf dem Rücken und
// später auf dem Kopf; ganz zum Schluss eine Papierlaterne an der Schulter.

void cityMarks(MarkSpot s, MarkMesh plain, MarkMesh glow) {
  final back = s.grown(s.surface.back, const [0.3, 0.6, 1]);
  for (var i = 0; i < back.length; i += 3) {
    _light(s, glow, back[i]);
  }
  if (s.level >= 2) {
    final top = s.surface.top;
    for (var i = 2; i < top.length; i += 6) {
      _light(s, glow, top[i]);
    }
  }
  if (s.level == 3 && s.surface.shoulders.isNotEmpty) {
    _lantern(s, plain, glow, s.surface.shoulders.first);
  }
}

void _light(MarkSpot s, MarkMesh glow, SurfacePoint p) =>
    glow.ball(p.at + p.normal * 0.004, s.between(0.013, 0.02), 0xffc75a);

/// Eine runde Papierlaterne, die an der Schulter hängt.
void _lantern(MarkSpot s, MarkMesh plain, MarkMesh glow, SurfacePoint p) {
  final k = s.scale * 1.5;
  final at = p.at + p.normal * 0.045 * k;
  final up = vm.Quaternion.identity();
  glow.blob(at, up, vm.Vector3(0.036, 0.04, 0.036) * k, 0xffb04a);
  for (final dy in [-1.0, 1.0]) {
    plain.blob(
      at + vm.Vector3(0, dy * 0.04 * k, 0),
      up,
      vm.Vector3(0.018, 0.007, 0.018) * k,
      0x5d4037,
    );
  }
  plain.blob(
    (at + p.at) * 0.5 + vm.Vector3(0, 0.045 * k, 0),
    along((at - p.at)..normalize(), math.pi / 2),
    vm.Vector3(0.003, 0.03 * k, 0.003),
    0x5d4037,
  );
}
