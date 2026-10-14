import 'dart:math' as math;

import 'package:vector_math/vector_math.dart' as vm;
import 'package:wandoo/features/creature/presentation/marks/mark_mesh.dart';
import 'package:wandoo/features/creature/presentation/marks/mark_spot.dart';
import 'package:wandoo/features/creature/presentation/marks/mark_surface.dart';

// Wald: ein Moospolster auf Kopf und Rücken, ganz zum Schluss zwei Blätter
// und ein kleiner Pilz.

const _moss = [0x5e9238, 0x6fa53f, 0x7fb547, 0x8fc254, 0x4f7f2f];

void forestMarks(MarkSpot s, MarkMesh mesh) {
  for (final p in s.grown(s.surface.top, const [0.3, 0.7, 1])) {
    _tuft(s, mesh, p);
  }
  for (final p in s.grown(s.surface.back, const [0, 0.5, 1])) {
    _tuft(s, mesh, p);
  }
  if (s.level < 3 || !s.headFree || s.surface.top.isEmpty) return;
  _leaves(s, mesh, s.surface.top.first);
  // Rechts hinten auf dem Kopf, damit er das Gesicht nicht verdeckt.
  final top = s.surface.top;
  final spot = top.reduce((a, b) => b.at.x - b.at.z > a.at.x - a.at.z ? b : a);
  _mushroom(s, mesh, spot);
}

/// Ein Büschel: flaches Polster mit drei Knubbeln darauf.
void _tuft(MarkSpot s, MarkMesh mesh, SurfacePoint p) {
  mesh.blob(
    p.at - p.normal * 0.004,
    along(p.normal, s.between(0, 6.3)),
    vm.Vector3(0.03, 0.008, 0.03),
    0x5a8c35,
  );
  for (var k = 0; k < 3; k++) {
    final r = s.between(0.011, 0.019);
    mesh.blob(
      s.beside(p, s.between(-0.02, 0.02), s.between(-0.02, 0.02), r * 0.3),
      along(p.normal),
      vm.Vector3(r, r * 0.6, r),
      _moss[s.random.nextInt(_moss.length)],
    );
  }
}

void _leaves(MarkSpot s, MarkMesh mesh, SurfacePoint p) {
  for (final (side, rgb) in [(0.9, 0x7cb342), (-0.6, 0x9ccc65)]) {
    final dir = (p.normal + vm.Vector3(side, 0, -0.2))..normalize();
    final length = 0.08 * s.scale;
    mesh.blob(
      p.at + dir * length,
      along(dir, math.pi / 2),
      vm.Vector3(0.032 * s.scale, length, 0.007),
      rgb,
    );
  }
}

void _mushroom(MarkSpot s, MarkMesh mesh, SurfacePoint p) {
  final k = s.scale;
  final turn = along(p.normal);
  mesh
    ..blob(
      p.at + p.normal * 0.025 * k,
      turn,
      vm.Vector3(0.017, 0.03, 0.017) * k,
      0xfff4e0,
    )
    ..blob(
      p.at + p.normal * 0.055 * k,
      turn,
      vm.Vector3(0.05, 0.026, 0.05) * k,
      0xe8574f,
    );
  for (var i = 0; i < 4; i++) {
    final a = i * 1.6;
    mesh.ball(
      s.beside(p, math.sin(a) * 0.03 * k, math.cos(a) * 0.03 * k, 0.072 * k),
      0.007 * k,
      0xffffff,
    );
  }
}
