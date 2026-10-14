import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart' as vm;
import 'package:wandoo/features/creature/presentation/model/model_parts.dart';

// Halsschmuck, Teil 1. [at] ist die Mitte des Halses, [r] sein Radius.
// Kleine Teile haben feste Größen, weil alle Modelle gleich groß sind.

void shellNecklace(Node root, vm.Vector3 at, double r) {
  root.add(
    part(
      TorusGeometry(radius: r, tubeRadius: 0.015),
      material(0.9, 0.82, 0.7),
      at,
    ),
  );
  final shell = material(1, 0.88, 0.86);
  final pink = material(1, 0.72, 0.74);
  for (var i = -2; i <= 2; i++) {
    root.add(
      part(
        SphereGeometry(radius: 0.04, segments: 12, rings: 6),
        i.isEven ? shell : pink,
        at + onRing(i * 0.07, r * 1.02) + vm.Vector3(0, -0.02, 0),
        scale: vm.Vector3(1, 1.2, 0.55),
      ),
    );
  }
}

void sparkleScarf(Node root, vm.Vector3 at, double r) {
  final purple = material(0.62, 0.48, 0.9);
  root
    ..add(part(TorusGeometry(radius: r, tubeRadius: 0.055), purple, at))
    ..add(
      part(
        CapsuleGeometry(radius: 0.04, height: 0.1),
        purple,
        at + onRing(0.1, r + 0.03) + vm.Vector3(0, -0.1, 0),
        rotation: vm.Quaternion.axisAngle(vm.Vector3(0, 0, 1), 0.2),
      ),
    );
  final dot = material(1, 0.95, 0.7)
    ..emissiveFactor = vm.Vector4(0.8, 0.75, 0.5, 1);
  for (var i = -3; i <= 3; i++) {
    root.add(
      part(
        SphereGeometry(radius: 0.014, segments: 8, rings: 4),
        dot,
        at + onRing(i * 0.05, r + 0.05),
      ),
    );
  }
}

void acornChain(Node root, vm.Vector3 at, double r) {
  root.add(
    part(
      TorusGeometry(radius: r, tubeRadius: 0.012),
      material(0.45, 0.3, 0.18),
      at,
    ),
  );
  final nut = material(0.62, 0.42, 0.24);
  final cap = material(0.4, 0.26, 0.15);
  for (var i = -2; i <= 2; i++) {
    final p = at + onRing(i * 0.07, r * 1.03);
    root
      ..add(
        part(
          SphereGeometry(radius: 0.026, segments: 12, rings: 6),
          nut,
          p + vm.Vector3(0, -0.03, 0),
          scale: vm.Vector3(1, 1.3, 1),
        ),
      )
      ..add(
        part(
          SphereGeometry(radius: 0.027, segments: 12, rings: 6),
          cap,
          p + vm.Vector3(0, -0.006, 0),
          scale: vm.Vector3(1, 0.55, 1),
        ),
      );
  }
}

void flowerLei(Node root, vm.Vector3 at, double r) {
  root.add(
    part(
      TorusGeometry(radius: r, tubeRadius: 0.014),
      material(0.35, 0.65, 0.35),
      at,
    ),
  );
  final colors = [
    material(1, 0.5, 0.6),
    material(1, 0.85, 0.35),
    material(0.98, 0.97, 0.95),
  ];
  for (var i = 0; i < 12; i++) {
    root.add(
      part(
        SphereGeometry(radius: 0.034, segments: 12, rings: 6),
        colors[i % 3],
        at + onRing(i / 12, r * 1.03),
        scale: vm.Vector3(1, 0.7, 1),
      ),
    );
  }
}

void bowTie(Node root, vm.Vector3 at, double r) {
  final red = material(0.85, 0.2, 0.25);
  final front = at + onRing(0, r * 1.02) + vm.Vector3(0, -0.01, 0);
  for (final side in [-1.0, 1.0]) {
    root.add(
      part(
        SphereGeometry(radius: 0.045, segments: 12, rings: 6),
        red,
        front + vm.Vector3(side * 0.045, 0, 0),
        scale: vm.Vector3(1.2, 0.85, 0.45),
      ),
    );
  }
  root.add(
    part(
      SphereGeometry(radius: 0.02, segments: 10, rings: 5),
      material(0.7, 0.12, 0.18),
      front + vm.Vector3(0, 0, 0.01),
    ),
  );
}

void bell(Node root, vm.Vector3 at, double r) {
  root.add(
    part(
      TorusGeometry(radius: r, tubeRadius: 0.018),
      material(0.85, 0.25, 0.3),
      at,
    ),
  );
  final front = at + onRing(0, r * 1.05) + vm.Vector3(0, -0.045, 0);
  root
    ..add(
      part(
        SphereGeometry(radius: 0.045, segments: 16, rings: 8),
        material(1, 0.8, 0.3, metallic: 0.7),
        front,
      ),
    )
    ..add(
      part(
        SphereGeometry(radius: 0.012, segments: 8, rings: 4),
        material(0.3, 0.2, 0.1),
        front + vm.Vector3(0, -0.03, 0.02),
      ),
    );
}
