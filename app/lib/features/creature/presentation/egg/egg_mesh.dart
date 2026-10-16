import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart' as vm;
import 'package:wandoo/features/creature/presentation/egg/egg_colors.dart';

/// Höhe des Eis in Modell-Einheiten (ein Wesen ist 1 hoch).
const eggHeight = 0.62;

/// Das Ei als 3D-Netz: unten breiter als oben, die Muster als Farben der
/// Eckpunkte. Steht mit der Spitze nach oben auf y = 0.
Node eggNode({required int theme, required Color accent, bool crack = false}) {
  const rings = 96;
  const segments = 96;
  final points = <vm.Vector3>[];
  final colors = <double>[];
  for (var r = 0; r <= rings; r++) {
    final polar = math.pi * r / rings;
    for (var s = 0; s <= segments; s++) {
      final p = _surface(polar, 2 * math.pi * s / segments);
      points.add(p);
      final c = eggColor(
        p.normalized(),
        theme: theme,
        accent: accent,
        crack: crack,
      );
      colors.addAll([_linear(c.x), _linear(c.y), _linear(c.z), 1]);
    }
  }
  const k = eggHeight / 1.04;
  final positions = <double>[];
  final normals = <double>[];
  const row = segments + 1;
  for (var i = 0; i < points.length; i++) {
    final r = i ~/ row;
    final s = i % row;
    final n = _normal(points, r, s, rings, segments);
    final p = points[i];
    positions.addAll([p.x * k, (p.y + 0.52) * k, p.z * k]);
    normals.addAll([n.x, n.y, n.z]);
  }
  final material = PhysicallyBasedMaterial()
    ..roughnessFactor = 0.85
    ..metallicFactor = 0;
  final geometry = MeshGeometry.fromArrays(
    positions: Float32List.fromList(positions),
    normals: Float32List.fromList(normals),
    colors: Float32List.fromList(colors),
    indices: _grid(rings, segments),
  );
  return Node(mesh: Mesh(geometry, material));
}

/// Zwei Dreiecke je Feld des Gitters aus Ringen und Segmenten.
List<int> _grid(int rings, int segments) {
  final row = segments + 1;
  return [
    for (var r = 0; r < rings; r++)
      for (var s = 0; s < segments; s++) ...[
        r * row + s,
        (r + 1) * row + s,
        r * row + s + 1,
        r * row + s + 1,
        (r + 1) * row + s,
        (r + 1) * row + s + 1,
      ],
  ];
}

/// Punkt der Schale wie im alten Shader: Ellipsoid, oben schmaler.
vm.Vector3 _surface(double polar, double around) {
  final y = 0.52 * math.cos(polar);
  final radius = 0.4 * math.sin(polar) / (1 + 0.22 * y);
  return vm.Vector3(radius * math.sin(around), y, radius * math.cos(around));
}

/// Senkrechte aus den Nachbarpunkten; an den Polen gerade nach oben/unten.
vm.Vector3 _normal(List<vm.Vector3> p, int r, int s, int rings, int segs) {
  if (r == 0) return vm.Vector3(0, 1, 0);
  if (r == rings) return vm.Vector3(0, -1, 0);
  final row = segs + 1;
  final down = p[(r + 1) * row + s] - p[(r - 1) * row + s];
  final side = p[r * row + (s + 1) % segs] - p[r * row + (s - 1 + segs) % segs];
  return down.cross(side)..normalize();
}

double _linear(double v) => math.pow(v.clamp(0.0, 1.0), 2.2).toDouble();
