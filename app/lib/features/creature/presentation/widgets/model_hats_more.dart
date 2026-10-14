import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart' as vm;
import 'package:wandoo/features/creature/presentation/widgets/model_parts.dart';

// Hüte, Teil 2: die seltenen mit Bauplan. Maße wie in `model_hats.dart`.

vm.Quaternion _roll(double angle) =>
    vm.Quaternion.axisAngle(vm.Vector3(0, 0, 1), angle);

PhysicallyBasedMaterial _glow(double r, double g, double b) =>
    material(r, g, b)..emissiveFactor = vm.Vector4(r, g, b, 1);

void bunnyEars(Node root, vm.Vector3 at, double r) {
  final fur = material(0.97, 0.95, 0.93);
  final inner = material(1, 0.72, 0.78);
  for (final side in [-1.0, 1.0]) {
    final tilt = _roll(-side * 0.25);
    final p = at + vm.Vector3(side * 0.32 * r, 0.55 * r, 0);
    root
      ..add(
        part(
          CapsuleGeometry(radius: 0.18 * r, height: 0.95 * r),
          fur,
          p,
          rotation: tilt,
          scale: vm.Vector3(1, 1, 0.6),
        ),
      )
      ..add(
        part(
          CapsuleGeometry(radius: 0.1 * r, height: 0.7 * r),
          inner,
          p + vm.Vector3(0, 0, 0.07 * r),
          rotation: tilt,
          scale: vm.Vector3(1, 1, 0.4),
        ),
      );
  }
}

void antlers(Node root, vm.Vector3 at, double r) {
  final wood = material(0.5, 0.33, 0.2);
  final leaf = material(0.4, 0.7, 0.35);
  for (final side in [-1.0, 1.0]) {
    final tilt = _roll(-side * 0.45);
    final base = at + vm.Vector3(side * 0.3 * r, 0.05 * r, 0);
    final up = tilt.rotated(vm.Vector3(0, 1, 0));
    final twig = _roll(-side * 1.1).rotated(vm.Vector3(0, 1, 0));
    root
      ..add(_stick(wood, base + up * (0.45 * r), 0.9 * r, r, tilt))
      ..add(
        _stick(
          wood,
          base + up * (0.5 * r) + twig * (0.2 * r),
          0.4 * r,
          r,
          _roll(-side * 1.1),
        ),
      )
      ..add(
        part(
          SphereGeometry(radius: 0.14 * r, segments: 10, rings: 5),
          leaf,
          base + up * (0.92 * r),
          scale: vm.Vector3(1, 0.6, 1),
        ),
      );
  }
}

Node _stick(
  Material wood,
  vm.Vector3 at,
  double length,
  double r,
  vm.Quaternion rotation,
) => part(
  CylinderGeometry(bottomRadius: 0.06 * r, topRadius: 0.04 * r, height: length),
  wood,
  at,
  rotation: rotation,
);

void topHat(Node root, vm.Vector3 at, double r) {
  final black = material(0.12, 0.12, 0.15);
  root
    ..add(
      part(
        CylinderGeometry(
          bottomRadius: 0.75 * r,
          topRadius: 0.75 * r,
          height: 0.05 * r,
        ),
        black,
        at + vm.Vector3(0, -0.06 * r, 0),
      ),
    )
    ..add(
      part(
        CylinderGeometry(
          bottomRadius: 0.42 * r,
          topRadius: 0.45 * r,
          height: 0.8 * r,
        ),
        black,
        at + vm.Vector3(0, 0.36 * r, 0),
      ),
    )
    ..add(
      part(
        TorusGeometry(radius: 0.43 * r, tubeRadius: 0.05 * r),
        material(0.8, 0.2, 0.25),
        at + vm.Vector3(0, 0.06 * r, 0),
      ),
    );
}

void wizardHat(Node root, vm.Vector3 at, double r) {
  final purple = material(0.42, 0.3, 0.75);
  final tilt = vm.Quaternion.axisAngle(vm.Vector3(1, 0, 0), -0.25);
  final up = tilt.rotated(vm.Vector3(0, 1, 0));
  root
    ..add(
      part(
        CylinderGeometry(
          bottomRadius: 0.9 * r,
          topRadius: 0.9 * r,
          height: 0.05 * r,
        ),
        purple,
        at + vm.Vector3(0, -0.06 * r, 0),
      ),
    )
    ..add(
      part(
        CylinderGeometry(
          bottomRadius: 0.62 * r,
          topRadius: 0.02 * r,
          height: 1.5 * r,
        ),
        purple,
        at + up * (0.7 * r),
        rotation: tilt,
      ),
    );
  final star = _glow(1, 0.88, 0.4);
  for (final (h, turn) in [(0.25, 0.02), (0.55, 0.12), (0.85, -0.05)]) {
    root.add(
      part(
        SphereGeometry(radius: 0.06 * r, segments: 8, rings: 4),
        star,
        at + up * (h * r) + onRing(turn, (0.5 - 0.35 * h) * r),
      ),
    );
  }
}

void starHalo(Node root, vm.Vector3 at, double r) {
  final base = at + vm.Vector3(0, 0.45 * r, 0);
  root.add(
    part(
      TorusGeometry(radius: 0.5 * r, tubeRadius: 0.035 * r),
      _glow(1, 0.85, 0.4),
      base,
    ),
  );
  final spark = _glow(1, 0.95, 0.7);
  for (var i = 0; i < 6; i++) {
    root.add(
      part(
        SphereGeometry(radius: 0.07 * r, segments: 10, rings: 5),
        spark,
        base + onRing(i / 6, 0.5 * r),
      ),
    );
  }
}
