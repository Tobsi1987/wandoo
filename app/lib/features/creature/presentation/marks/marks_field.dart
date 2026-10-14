import 'dart:math' as math;

import 'package:vector_math/vector_math.dart' as vm;
import 'package:wandoo/features/creature/presentation/marks/mark_mesh.dart';
import 'package:wandoo/features/creature/presentation/marks/mark_spot.dart';
import 'package:wandoo/features/creature/presentation/marks/mark_surface.dart';

// Feld: ein Gänseblümchen-Kranz, der Blüte um Blüte wächst, ganz zum
// Schluss sitzt ein Marienkäfer auf der Schulter.

void fieldMarks(MarkSpot s, MarkMesh mesh) {
  final ring = s.surface.ring;
  final every = switch (s.level) {
    1 => 3,
    2 => 2,
    _ => 1,
  };
  for (var i = 0; i < ring.length; i += every) {
    final petals = i % 3 == 2 ? 0xffd1e0 : 0xffffff;
    _daisy(s, mesh, ring[i], petals);
  }
  if (s.level == 3 && s.surface.shoulders.isNotEmpty) {
    _ladybug(s, mesh, s.surface.shoulders.first);
  }
}

void _daisy(MarkSpot s, MarkMesh mesh, SurfacePoint p, int petals) {
  final k = s.scale * 1.6;
  final face = (p.normal + vm.Vector3(0, 0.6, 0))..normalize();
  final flower = SurfacePoint(p.at + face * 0.006, face);
  for (var i = 0; i < 8; i++) {
    final a = i / 8 * 2 * math.pi;
    mesh.blob(
      s.beside(flower, math.sin(a) * 0.026 * k, math.cos(a) * 0.026 * k),
      along(face, a),
      vm.Vector3(0.01, 0.004, 0.02) * k,
      petals,
    );
  }
  mesh.blob(
    flower.at + face * 0.004,
    along(face),
    vm.Vector3(0.013, 0.008, 0.013) * k,
    0xf5c623,
  );
}

void _ladybug(MarkSpot s, MarkMesh mesh, SurfacePoint p) {
  final k = s.scale;
  final turn = along(p.normal, 0.4);
  mesh
    ..blob(
      p.at + p.normal * 0.008,
      turn,
      vm.Vector3(0.024, 0.016, 0.03) * k,
      0xe53935,
    )
    ..ball(s.beside(p, 0, 0.03 * k, 0.008), 0.012 * k, 0x222222);
  for (final (dx, dz) in [
    (0.012, 0.008),
    (-0.012, 0.008),
    (0.01, -0.012),
    (-0.01, -0.012),
  ]) {
    mesh.ball(s.beside(p, dx * k, dz * k, 0.021 * k), 0.005 * k, 0x222222);
  }
}
