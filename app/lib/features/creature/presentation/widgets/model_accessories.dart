import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart' as vm;
import 'package:wandoo/features/creature/domain/outfit.dart';
import 'package:wandoo/features/creature/presentation/widgets/model_anchors.dart';
import 'package:wandoo/features/creature/presentation/widgets/model_parts.dart';
import 'package:wandoo/features/creature/presentation/widgets/model_weather_gear.dart';

/// Hut und Halsschmuck als kleine 3D-Teile, die auf dem Modell sitzen.
///
/// Formen und Farben wie im Shader (`shaders/accessories.glsl`); die Teile
/// liegen in Modell-Koordinaten (vorne ist +z) und bewegen sich mit.
Node modelAccessories(ModelAnchors at, Outfit outfit) {
  // Wie die Wurzel eines glb: vorne (+z) zeigt zur Kamera.
  final root = Node(
    name: 'accessories',
    localTransform: vm.Matrix4.diagonal3Values(1, 1, -1),
  );
  final hatAt = vm.Vector3(0, at.hatY, at.hatZ);
  final neckAt = vm.Vector3(0, at.neckY, at.neckZ);
  weatherGear(root, outfit.gear, hatAt, at.headRadius);
  // Die Mütze ersetzt den Hut.
  final hat = outfit.gear == WeatherGear.beanie ? null : outfit.hat;
  switch (hat) {
    case CreatureHat.acornCap:
      _acornCap(root, hatAt, at.headRadius);
    case CreatureHat.flowerCrown:
      _flowerCrown(root, hatAt, at.headRadius);
    case CreatureHat.starCrown:
      _starCrown(root, hatAt, at.headRadius);
    case null:
  }
  switch (outfit.neck) {
    case CreatureNeck.shellNecklace:
      _shellNecklace(root, neckAt, at.neckRadius);
    case CreatureNeck.sparkleScarf:
      _sparkleScarf(root, neckAt, at.neckRadius);
    case null:
  }
  return root;
}

void _acornCap(Node root, vm.Vector3 at, double r) {
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

void _flowerCrown(Node root, vm.Vector3 at, double r) {
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

void _starCrown(Node root, vm.Vector3 at, double r) {
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

void _shellNecklace(Node root, vm.Vector3 at, double r) {
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

void _sparkleScarf(Node root, vm.Vector3 at, double r) {
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
