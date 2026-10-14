import 'dart:math' as math;

import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart' as vm;

// Bausteine für kleine 3D-Teile am Modell (Hut, Schal, Schirm, Mütze).

/// Punkt auf einem waagerechten Kreis; Anteil 0 liegt vorne (+z).
vm.Vector3 onRing(double turn, double radius) {
  final a = turn * 2 * math.pi;
  return vm.Vector3(radius * math.sin(a), 0, radius * math.cos(a));
}

Node part(
  Geometry geometry,
  Material material,
  vm.Vector3 position, {
  vm.Vector3? scale,
  vm.Quaternion? rotation,
}) => Node(
  localTransform: vm.Matrix4.compose(
    position,
    rotation ?? vm.Quaternion.identity(),
    scale ?? vm.Vector3.all(1),
  ),
  mesh: Mesh(geometry, material),
);

PhysicallyBasedMaterial material(
  double r,
  double g,
  double b, {
  double metallic = 0,
}) => PhysicallyBasedMaterial()
  ..baseColorFactor = vm.Vector4(r, g, b, 1)
  ..roughnessFactor = 0.75
  ..metallicFactor = metallic;
