import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart' as vm;
import 'package:wandoo/features/creature/presentation/model/model_parts.dart';

// Hüte, einfache und mittlere. [at] ist der Platz oben auf dem Kopf,
// [r] der Kopfradius; alles wächst mit dem Kopf mit.

void bow(Node root, vm.Vector3 at, double r) {
  final pink = material(1, 0.5, 0.62);
  final base = at + vm.Vector3(0.38 * r, -0.12 * r, 0.1 * r);
  for (final side in [-1.0, 1.0]) {
    root.add(
      part(
        SphereGeometry(radius: 0.2 * r, segments: 16, rings: 8),
        pink,
        base + vm.Vector3(side * 0.2 * r, 0, 0),
        scale: vm.Vector3(1.2, 0.8, 0.45),
        rotation: vm.Quaternion.axisAngle(vm.Vector3(0, 0, 1), side * 0.3),
      ),
    );
  }
  root.add(
    part(
      SphereGeometry(radius: 0.09 * r, segments: 12, rings: 6),
      material(0.9, 0.35, 0.5),
      base,
    ),
  );
}

void mushroomCap(Node root, vm.Vector3 at, double r) {
  root.add(
    part(
      SphereGeometry(radius: 0.78 * r),
      material(0.88, 0.25, 0.22),
      at + vm.Vector3(0, -0.05 * r, 0),
      scale: vm.Vector3(1, 0.55, 1),
    ),
  );
  final white = material(0.98, 0.96, 0.9);
  for (var i = 0; i < 6; i++) {
    root.add(
      part(
        SphereGeometry(radius: 0.1 * r, segments: 12, rings: 6),
        white,
        at + onRing(i / 6 + 0.08, 0.5 * r) + vm.Vector3(0, 0.2 * r, 0),
        scale: vm.Vector3(1, 0.5, 1),
      ),
    );
  }
}

void strawHat(Node root, vm.Vector3 at, double r) {
  final straw = material(0.93, 0.8, 0.48);
  root
    ..add(
      part(
        CylinderGeometry(
          bottomRadius: 1.05 * r,
          topRadius: 1.05 * r,
          height: 0.05 * r,
        ),
        straw,
        at + vm.Vector3(0, -0.08 * r, 0),
      ),
    )
    ..add(
      part(
        CylinderGeometry(
          bottomRadius: 0.52 * r,
          topRadius: 0.46 * r,
          height: 0.36 * r,
        ),
        straw,
        at + vm.Vector3(0, 0.1 * r, 0),
      ),
    )
    ..add(
      part(
        TorusGeometry(radius: 0.51 * r, tubeRadius: 0.05 * r),
        material(0.85, 0.3, 0.3),
        at + vm.Vector3(0, -0.02 * r, 0),
      ),
    );
}

void sailorCap(Node root, vm.Vector3 at, double r) {
  root
    ..add(
      part(
        CylinderGeometry(
          bottomRadius: 0.58 * r,
          topRadius: 0.62 * r,
          height: 0.3 * r,
        ),
        material(0.97, 0.97, 0.97),
        at + vm.Vector3(0, 0.02 * r, 0),
      ),
    )
    ..add(
      part(
        TorusGeometry(radius: 0.58 * r, tubeRadius: 0.07 * r),
        material(0.2, 0.35, 0.7),
        at + vm.Vector3(0, -0.1 * r, 0),
      ),
    )
    ..add(
      part(
        SphereGeometry(radius: 0.12 * r, segments: 12, rings: 6),
        material(0.9, 0.25, 0.25),
        at + vm.Vector3(0, 0.2 * r, 0),
      ),
    );
}

void partyHat(Node root, vm.Vector3 at, double r) {
  final tilt = vm.Quaternion.axisAngle(vm.Vector3(0, 0, 1), -0.2);
  final up = tilt.rotated(vm.Vector3(0, 1, 0));
  root
    ..add(
      part(
        CylinderGeometry(
          bottomRadius: 0.5 * r,
          topRadius: 0.03 * r,
          height: 1.2 * r,
        ),
        material(1, 0.5, 0.7),
        at + up * (0.5 * r),
        rotation: tilt,
      ),
    )
    ..add(
      part(
        SphereGeometry(radius: 0.17 * r, segments: 12, rings: 6),
        material(1, 0.85, 0.3),
        at + up * (1.12 * r),
      ),
    );
  final dot = material(0.35, 0.75, 0.95);
  for (var i = 0; i < 3; i++) {
    root.add(
      part(
        SphereGeometry(radius: 0.06 * r, segments: 8, rings: 4),
        dot,
        at +
            up * ((0.15 + 0.2 * i) * r) +
            vm.Vector3(0, 0, (0.3 - 0.08 * i) * r),
      ),
    );
  }
}
