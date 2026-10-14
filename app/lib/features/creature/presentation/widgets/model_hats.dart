import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart' as vm;
import 'package:wandoo/features/creature/presentation/widgets/model_parts.dart';

// Hüte, Teil 1: die ersten drei. [at] ist der Platz oben auf dem Kopf, [r] der
// Kopfradius; alles wächst mit dem Kopf mit.

void acornCap(Node root, vm.Vector3 at, double r) {
  final brown = material(0.55, 0.36, 0.2);
  root
    ..add(
      part(
        SphereGeometry(radius: 0.62 * r),
        brown,
        at + vm.Vector3(0, -0.02 * r, 0),
        scale: vm.Vector3(1, 0.62, 1),
      ),
    )
    ..add(
      part(
        TorusGeometry(radius: 0.58 * r, tubeRadius: 0.08 * r),
        material(0.42, 0.26, 0.14),
        at + vm.Vector3(0, -0.08 * r, 0),
      ),
    )
    ..add(
      part(
        CylinderGeometry(
          bottomRadius: 0.07 * r,
          topRadius: 0.05 * r,
          height: 0.3 * r,
        ),
        brown,
        at + vm.Vector3(0, 0.45 * r, 0),
      ),
    );
}

void flowerCrown(Node root, vm.Vector3 at, double r) {
  final base = at + vm.Vector3(0, -0.12 * r, 0);
  root.add(
    part(
      TorusGeometry(radius: 0.62 * r, tubeRadius: 0.04 * r),
      material(0.35, 0.65, 0.35),
      base,
    ),
  );
  final pink = material(1, 0.45, 0.5);
  final yellow = material(1, 0.85, 0.35);
  for (var i = 0; i < 7; i++) {
    root.add(
      part(
        SphereGeometry(radius: 0.13 * r, segments: 16, rings: 8),
        i.isEven ? pink : yellow,
        base + onRing(i / 7, 0.62 * r),
      ),
    );
  }
}

void starCrown(Node root, vm.Vector3 at, double r) {
  final base = at + vm.Vector3(0, -0.1 * r, 0);
  final gold = material(1, 0.8, 0.3, metallic: 0.6);
  root.add(
    part(TorusGeometry(radius: 0.55 * r, tubeRadius: 0.08 * r), gold, base),
  );
  final glow = material(1, 0.93, 0.6)
    ..emissiveFactor = vm.Vector4(1, 0.85, 0.4, 1);
  for (var i = 0; i < 5; i++) {
    final p = base + onRing(i / 5, 0.55 * r);
    root
      ..add(
        part(
          CylinderGeometry(
            bottomRadius: 0.1 * r,
            topRadius: 0.01 * r,
            height: 0.32 * r,
          ),
          gold,
          p + vm.Vector3(0, 0.16 * r, 0),
        ),
      )
      ..add(
        part(
          SphereGeometry(radius: 0.06 * r, segments: 12, rings: 6),
          glow,
          p + vm.Vector3(0, 0.34 * r, 0),
        ),
      );
  }
}
