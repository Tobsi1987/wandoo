import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart' as vm;
import 'package:wandoo/features/creature/domain/outfit.dart';
import 'package:wandoo/features/creature/presentation/widgets/model_parts.dart';

/// Schirm oder Mütze; [hatAt] ist der Platz für den Hut, [r] der Kopf.
void weatherGear(Node root, WeatherGear? gear, vm.Vector3 hatAt, double r) {
  switch (gear) {
    case WeatherGear.umbrella:
      _umbrella(root, hatAt, r);
    case WeatherGear.beanie:
      _beanie(root, hatAt, r);
    case null:
  }
}

/// Ein gelber Schirm mit roten Zipfeln, leicht zur Seite und nach vorn
/// geneigt über dem Kopf, damit man ihn von vorn als Schirm erkennt.
void _umbrella(Node root, vm.Vector3 hatAt, double r) {
  final tilt =
      vm.Quaternion.axisAngle(vm.Vector3(0, 0, 1), -0.25) *
      vm.Quaternion.axisAngle(vm.Vector3(1, 0, 0), 0.3);
  final holder = Node(
    localTransform: vm.Matrix4.compose(
      hatAt + vm.Vector3(0.7 * r, 0.15 * r, 0),
      tilt,
      vm.Vector3.all(1),
    ),
  );
  _canopy(holder, r);
  _stick(holder, r);
  root.add(holder);
}

/// Das gelbe Dach mit roter Spitze und roten Zipfeln rundum.
void _canopy(Node holder, double r) {
  final yellow = material(1, 0.8, 0.22);
  final red = material(0.93, 0.33, 0.33);
  holder
    ..add(
      part(
        CylinderGeometry(
          bottomRadius: 1.05 * r,
          topRadius: 0.04 * r,
          height: 0.6 * r,
        ),
        yellow,
        vm.Vector3(0, 0.3 * r, 0),
      ),
    )
    ..add(
      part(
        SphereGeometry(radius: 0.1 * r, segments: 12, rings: 6),
        red,
        vm.Vector3(0, 0.63 * r, 0),
      ),
    );
  for (var i = 0; i < 8; i++) {
    holder.add(
      part(
        SphereGeometry(radius: 0.11 * r, segments: 12, rings: 6),
        red,
        onRing(i / 8, 1.03 * r),
        scale: vm.Vector3(1, 0.6, 1),
      ),
    );
  }
}

/// Holzstock mit gebogenem Griff.
void _stick(Node holder, double r) {
  final wood = material(0.5, 0.33, 0.2);
  holder
    ..add(
      part(
        CylinderGeometry(
          bottomRadius: 0.06 * r,
          topRadius: 0.06 * r,
          height: 1.4 * r,
        ),
        wood,
        vm.Vector3(0, -0.4 * r, 0),
      ),
    )
    ..add(
      part(
        TorusGeometry(radius: 0.14 * r, tubeRadius: 0.06 * r),
        wood,
        vm.Vector3(0.14 * r, -1.1 * r, 0),
        rotation: vm.Quaternion.axisAngle(vm.Vector3(1, 0, 0), 1.57),
      ),
    );
}

/// Eine rote Wollmütze mit weißem Rand und Bommel.
void _beanie(Node root, vm.Vector3 hatAt, double r) {
  final red = material(0.86, 0.32, 0.36);
  final white = material(0.96, 0.95, 0.92);
  root
    ..add(
      part(
        SphereGeometry(radius: 0.66 * r),
        red,
        hatAt + vm.Vector3(0, -0.1 * r, 0),
        scale: vm.Vector3(1, 0.8, 1),
      ),
    )
    ..add(
      part(
        TorusGeometry(radius: 0.64 * r, tubeRadius: 0.12 * r),
        white,
        hatAt + vm.Vector3(0, -0.22 * r, 0),
      ),
    )
    ..add(
      part(
        SphereGeometry(radius: 0.2 * r, segments: 16, rings: 8),
        white,
        hatAt + vm.Vector3(0, 0.48 * r, 0),
      ),
    );
}
