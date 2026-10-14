import 'dart:math' as math;

import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart' as vm;

// Bausteine für die Möbel. Ein Möbelstück steht auf dem Boden (y = 0),
// ist etwa eine Einheit breit, und +z zeigt zum Betrachter.

typedef V = vm.Vector3;

Node piece(
  Geometry geometry,
  Material material,
  V position, {
  V? scale,
  vm.Quaternion? rotation,
}) => Node(
  localTransform: vm.Matrix4.compose(
    position,
    rotation ?? vm.Quaternion.identity(),
    scale ?? V.all(1),
  ),
  mesh: Mesh(geometry, material),
);

PhysicallyBasedMaterial paint(int rgb, {double glow = 0}) {
  final r = (rgb >> 16 & 0xff) / 255;
  final g = (rgb >> 8 & 0xff) / 255;
  final b = (rgb & 0xff) / 255;
  final m = PhysicallyBasedMaterial()
    ..baseColorFactor = vm.Vector4(r, g, b, 1)
    ..roughnessFactor = 0.8
    ..metallicFactor = 0;
  if (glow > 0) m.emissiveFactor = vm.Vector4(r * glow, g * glow, b * glow, 1);
  return m;
}

Geometry ball(double radius) =>
    SphereGeometry(radius: radius, segments: 20, rings: 10);

Geometry tube(double radius, double height, {double? top}) => CylinderGeometry(
  bottomRadius: radius,
  topRadius: top ?? radius,
  height: height,
  radialSegments: 24,
);

Geometry box(double x, double y, double z) => CuboidGeometry(V(x, y, z));

Geometry donut(double radius, double tube) => TorusGeometry(
  radius: radius,
  tubeRadius: tube,
  radialSegments: 28,
  tubularSegments: 12,
);

/// Dreht ein Teil, das sonst flach liegt, so dass es nach vorne schaut.
final faceFront = vm.Quaternion.axisAngle(V(1, 0, 0), math.pi / 2);

vm.Quaternion turn(V axis, double angle) =>
    vm.Quaternion.axisAngle(axis, angle);

/// Punkt auf einem Kreis in der x-y-Ebene (an der Wand), 0 liegt oben.
V onWall(double share, double radius, V center) {
  final a = share * 2 * math.pi;
  return center + V(radius * math.sin(a), radius * math.cos(a), 0);
}

/// Punkt auf einem waagerechten Kreis, 0 liegt vorne.
V onFloor(double share, double radius, V center) {
  final a = share * 2 * math.pi;
  return center + V(radius * math.sin(a), 0, radius * math.cos(a));
}

/// Ein Knoten unter [root], in dem alles [s]-mal so groß ist.
Node grow(Node root, double s) {
  final node = Node(localTransform: vm.Matrix4.diagonal3Values(s, s, s));
  root.add(node);
  return node;
}
