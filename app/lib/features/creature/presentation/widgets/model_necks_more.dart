import 'dart:math' as math;

import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart' as vm;
import 'package:wandoo/features/creature/presentation/widgets/model_parts.dart';

// Halsschmuck, Teil 2: die seltenen mit Bauplan. Maße wie in
// `model_necks.dart`.

void knitScarf(Node root, vm.Vector3 at, double r) {
  final red = material(0.85, 0.28, 0.3);
  final white = material(0.97, 0.95, 0.92);
  root.add(part(TorusGeometry(radius: r, tubeRadius: 0.05), red, at));
  for (final y in [-0.02, 0.02]) {
    root.add(
      part(
        TorusGeometry(radius: r + 0.012, tubeRadius: 0.012),
        white,
        at + vm.Vector3(0, y, 0),
      ),
    );
  }
  // Ein Ende hängt vorne links herunter, geringelt.
  final end = at + onRing(0.08, r + 0.03);
  for (var i = 0; i < 3; i++) {
    root.add(
      part(
        CylinderGeometry(bottomRadius: 0.035, topRadius: 0.035, height: 0.05),
        i.isEven ? red : white,
        end + vm.Vector3(0, -0.06 - 0.05 * i, 0),
      ),
    );
  }
}

void pearlNecklace(Node root, vm.Vector3 at, double r) {
  final pearl = material(0.97, 0.95, 0.92, metallic: 0.3);
  for (var i = 0; i < 18; i++) {
    root.add(
      part(
        SphereGeometry(radius: 0.02, segments: 10, rings: 5),
        pearl,
        at + onRing(i / 18, r * 1.02),
      ),
    );
  }
  root.add(
    part(
      SphereGeometry(radius: 0.03, segments: 12, rings: 6),
      material(1, 0.75, 0.85)..emissiveFactor = vm.Vector4(0.6, 0.4, 0.5, 1),
      at + onRing(0, r * 1.05) + vm.Vector3(0, -0.04, 0),
    ),
  );
}

void medal(Node root, vm.Vector3 at, double r) {
  root.add(
    part(
      TorusGeometry(radius: r, tubeRadius: 0.014),
      material(0.25, 0.45, 0.85),
      at,
    ),
  );
  final front = at + onRing(0, r * 1.25) + vm.Vector3(0, -0.06, 0);
  final faceFront = vm.Quaternion.axisAngle(vm.Vector3(1, 0, 0), math.pi / 2);
  root
    ..add(
      part(
        CylinderGeometry(bottomRadius: 0.065, topRadius: 0.065, height: 0.015),
        material(1, 0.78, 0.25, metallic: 0.7),
        front,
        rotation: faceFront,
      ),
    )
    ..add(
      part(
        SphereGeometry(radius: 0.025, segments: 8, rings: 4),
        material(1, 0.95, 0.6)..emissiveFactor = vm.Vector4(1, 0.9, 0.5, 1),
        front + vm.Vector3(0, 0, 0.012),
      ),
    );
}

void cape(Node root, vm.Vector3 at, double r) {
  final red = material(0.78, 0.18, 0.25);
  root
    ..add(part(TorusGeometry(radius: r, tubeRadius: 0.03), red, at))
    ..add(
      part(
        SphereGeometry(radius: 0.34),
        red,
        at + vm.Vector3(0, -0.22, -r * 1.05),
        scale: vm.Vector3(1.3, 1.15, 0.22),
      ),
    )
    ..add(
      part(
        SphereGeometry(radius: 0.02, segments: 8, rings: 4),
        material(1, 0.8, 0.3, metallic: 0.7),
        at + onRing(0, r * 1.03),
      ),
    );
}
