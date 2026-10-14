import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart' as vm;

/// Sammelt viele kleine Kugeln zu einem einzigen Netz: So sind hundert
/// Moosbüschel nur ein Zeichenaufruf.
class MarkMesh {
  final _positions = <double>[];
  final _normals = <double>[];
  final _colors = <double>[];
  final _indices = <int>[];

  bool get isEmpty => _indices.isEmpty;

  /// Ein Ellipsoid mit den Halbachsen [size] (y zeigt entlang [turn]) in der
  /// Farbe [rgb] (z. B. 0x6fa53f).
  void blob(vm.Vector3 at, vm.Quaternion turn, vm.Vector3 size, int rgb) {
    final first = _positions.length ~/ 3;
    final color = _linear(rgb);
    for (final u in _unitSphere) {
      final p = turn.rotated(
        vm.Vector3(u.x * size.x, u.y * size.y, u.z * size.z),
      )..add(at);
      final n = turn.rotated(
        vm.Vector3(u.x / size.x, u.y / size.y, u.z / size.z)..normalize(),
      );
      _positions.addAll([p.x, p.y, p.z]);
      _normals.addAll([n.x, n.y, n.z]);
      _colors.addAll(color);
    }
    _indices.addAll([for (final i in _sphereIndices) first + i]);
  }

  /// Eine Kugel mit Radius [r].
  void ball(vm.Vector3 at, double r, int rgb) =>
      blob(at, vm.Quaternion.identity(), vm.Vector3.all(r), rgb);

  /// Alles als Knoten, oder null, wenn nichts dazukam.
  Node? node({double roughness = 0.9, vm.Vector4? glow}) {
    if (isEmpty) return null;
    final material = PhysicallyBasedMaterial()
      ..roughnessFactor = roughness
      ..metallicFactor = 0;
    if (glow != null) material.emissiveFactor = glow;
    return Node(
      mesh: Mesh(
        MeshGeometry.fromArrays(
          positions: Float32List.fromList(_positions),
          normals: Float32List.fromList(_normals),
          colors: Float32List.fromList(_colors),
          indices: _indices,
        ),
        material,
      ),
    );
  }

  static List<double> _linear(int rgb) => [
    for (final shift in [16, 8, 0])
      math.pow(((rgb >> shift) & 0xff) / 255, 2.2).toDouble(),
    1,
  ];

  static const _segments = 10;
  static const _rings = 6;

  static final List<vm.Vector3> _unitSphere = [
    for (var r = 0; r <= _rings; r++)
      for (var s = 0; s <= _segments; s++)
        vm.Vector3(
          math.sin(math.pi * r / _rings) *
              math.sin(2 * math.pi * s / _segments),
          math.cos(math.pi * r / _rings),
          math.sin(math.pi * r / _rings) *
              math.cos(2 * math.pi * s / _segments),
        ),
  ];

  static final List<int> _sphereIndices = [
    for (var r = 0; r < _rings; r++)
      for (var s = 0; s < _segments; s++) ...[
        r * (_segments + 1) + s,
        (r + 1) * (_segments + 1) + s,
        r * (_segments + 1) + s + 1,
        r * (_segments + 1) + s + 1,
        (r + 1) * (_segments + 1) + s,
        (r + 1) * (_segments + 1) + s + 1,
      ],
  ];
}

/// Dreht die y-Achse auf [normal] und dann [spin] um sie herum.
vm.Quaternion along(vm.Vector3 normal, [double spin = 0]) =>
    vm.Quaternion.fromTwoVectors(vm.Vector3(0, 1, 0), normal) *
    vm.Quaternion.axisAngle(vm.Vector3(0, 1, 0), spin);
