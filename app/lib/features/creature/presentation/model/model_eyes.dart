import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart' as vm;

/// Wo das rechte Auge eines 3D-Modells sitzt (das linke liegt gespiegelt),
/// in Tausendstel Modell-Einheiten: Mitte x, y, z (vorne auf der Wölbung),
/// halbe Breite und Höhe, Blickrichtung x und y, dazu die Hautfarbe darum.
///
/// Abgemessen an Vorderansichten der Modelle aus `assets/creatures/`.
class EyeSpot {
  const EyeSpot(
    this.x,
    this.y,
    this.z,
    this.halfWidth,
    this.halfHeight,
    this.lookX,
    this.lookY,
    this.skin,
  );

  final int x;
  final int y;
  final int z;
  final int halfWidth;
  final int halfHeight;
  final int lookX;
  final int lookY;

  /// Farbe als 0xAARRGGBB.
  final int skin;
}

/// Geschlossene Augen zum Schlafen: über jedem Auge ein Lid in Hautfarbe
/// mit einem dunklen Strich darauf. Liegt wie ein glb (vorne ist +z).
Node modelEyelids(EyeSpot e) {
  final root = Node(
    name: 'eyelids',
    localTransform: vm.Matrix4.diagonal3Values(1, 1, -1),
  );
  final skin = _material(Color(e.skin));
  final lash = _material(const Color(0xFF2B1F24));
  final w = e.halfWidth / 1000;
  final h = e.halfHeight / 1000;
  for (final side in const [-1.0, 1.0]) {
    final nx = side * e.lookX / 1000;
    final ny = e.lookY / 1000;
    final look = vm.Vector3(
      nx,
      ny,
      math.sqrt(math.max(0, 1 - nx * nx - ny * ny)),
    );
    final turn = vm.Quaternion.fromTwoVectors(vm.Vector3(0, 0, 1), look);
    final top = vm.Vector3(side * e.x / 1000, e.y / 1000, e.z / 1000);
    final lid = top - look * (0.3 * w);
    root
      ..add(_part(lid, turn, vm.Vector3(1.12 * w, 1.12 * h, 0.55 * w), skin))
      ..add(
        _part(
          lid + turn.rotated(vm.Vector3(0, -0.1 * h, 0.45 * w)),
          turn,
          vm.Vector3(0.85 * w, 0.13 * h, 0.32 * w),
          lash,
        ),
      );
  }
  return root;
}

Node _part(vm.Vector3 at, vm.Quaternion turn, vm.Vector3 size, Material m) =>
    Node(
      localTransform: vm.Matrix4.compose(at, turn, size),
      mesh: Mesh(SphereGeometry(radius: 1), m),
    );

/// Farbe aus dem Bild (sRGB) in den linearen Wert des Materials.
PhysicallyBasedMaterial _material(Color c) {
  double lin(double v) => math.pow(v, 2.2).toDouble();
  return PhysicallyBasedMaterial()
    ..baseColorFactor = vm.Vector4(lin(c.r), lin(c.g), lin(c.b), 1)
    ..roughnessFactor = 0.8
    ..metallicFactor = 0;
}

/// Gemessene Augen je Art.
const modelEyes = <String, EyeSpot>{
  'aurora': EyeSpot(124, 582, 322, 62, 80, 285, -5, 0xFFE0D8D6),
  'blaetterdrache': EyeSpot(163, 632, 255, 46, 59, 495, 110, 0xFF8DC84C),
  'blaetterdrache2': EyeSpot(112, 721, 236, 24, 45, 630, 250, 0xFF9BBA6E),
  'blaetterdrache3': EyeSpot(97, 704, 361, 16, 26, 700, 100, 0xFFA0C28E),
  'blitzmaus': EyeSpot(134, 507, 212, 36, 50, 385, 180, 0xFF77B4BA),
  'blitzmaus2': EyeSpot(85, 535, 155, 31, 36, 500, 0, 0xFF8F9EA0),
  'blitzmaus3': EyeSpot(94, 550, 210, 38, 40, 400, 150, 0xFF4A8C94),
  'brummli': EyeSpot(147, 520, 282, 71, 76, 340, 240, 0xFFD9C07E),
  'brummli2': EyeSpot(112, 603, 251, 60, 64, 300, 220, 0xFFEDD79B),
  'brummli3': EyeSpot(96, 682, 210, 36, 38, 430, 115, 0xFFECA88A),
  'fluffeule': EyeSpot(129, 663, 261, 90, 90, 100, 105, 0xFFE2C6AA),
  'fluffeule2': EyeSpot(94, 715, 212, 48, 50, 280, 185, 0xFFEDDBBF),
  'fluffeule3': EyeSpot(122, 678, 190, 66, 50, 240, 220, 0xFFE6BE8C),
  'funkel': EyeSpot(136, 678, 300, 59, 69, 235, 175, 0xFFE2A672),
  'funkel2': EyeSpot(87, 822, 315, 31, 36, 225, 235, 0xFFF4B086),
  'funkel3': EyeSpot(48, 690, 325, 11, 22, 595, 150, 0xFFD9A38C),
  'glutling': EyeSpot(130, 575, 250, 52, 60, 255, 260, 0xFFE4544A),
  'kieselchen': EyeSpot(176, 765, 247, 64, 64, 285, 295, 0xFFE0D2C2),
  'kieselchen2': EyeSpot(128, 605, 262, 45, 54, 170, 90, 0xFFD0C5BD),
  'kieselchen3': EyeSpot(104, 678, 197, 23, 22, 135, 90, 0xFFD7D0C6),
  'kristallis': EyeSpot(142, 488, 248, 50, 54, 290, 135, 0xFFE1C5AE),
  'kristallis2': EyeSpot(108, 564, 258, 26, 34, 250, 110, 0xFFDEC4B4),
  'kristallis3': EyeSpot(78, 660, 220, 35, 35, 300, 100, 0xFFC89696),
  'laternchen': EyeSpot(136, 556, 238, 57, 66, 455, 10, 0xFFFEE0AC),
  'laternchen2': EyeSpot(100, 576, 210, 53, 50, 300, 150, 0xFF2C3766),
  'laternchen3': EyeSpot(107, 528, 244, 42, 42, 300, 190, 0xFF4E5F79),
  'moosel': EyeSpot(220, 581, 420, 74, 84, 335, 5, 0xFFB0E1B4),
  'moosel2': EyeSpot(102, 660, 259, 20, 30, 250, 110, 0xFFA9CB94),
  'moosel3': EyeSpot(90, 562, 230, 13, 23, 870, 25, 0xFFACB88F),
  'nebelfuchs': EyeSpot(133, 502, 642, 59, 62, 135, 15, 0xFFBCCEDC),
  'pfuetzling': EyeSpot(228, 554, 313, 86, 102, 410, 30, 0xFFB4ECF4),
  'pfuetzling2': EyeSpot(151, 560, 300, 60, 67, 440, -25, 0xFFACDAE3),
  'pfuetzling3': EyeSpot(51, 786, 283, 18, 21, 480, 75, 0xFFD1FCFB),
  'pilzling': EyeSpot(162, 531, 256, 41, 46, 140, 50, 0xFFDDCBB8),
  'pilzling2': EyeSpot(115, 593, 186, 30, 34, 460, 20, 0xFFD9CAB8),
  'pilzling3': EyeSpot(105, 647, 115, 14, 13, 600, -130, 0xFFE8DCC8),
  'pustel': EyeSpot(117, 484, 315, 55, 60, 480, 265, 0xFFDCCEBC),
  'pustel2': EyeSpot(110, 513, 217, 26, 36, 440, 245, 0xFFF1E1B0),
  'pustel3': EyeSpot(103, 448, 230, 27, 31, 425, 5, 0xFFE6E2CF),
  'schnirp': EyeSpot(131, 525, 332, 69, 74, 285, 145, 0xFFA4D8D4),
  'schnirp2': EyeSpot(66, 593, 355, 41, 39, 230, 350, 0xFFA1DBDF),
  'schnirp3': EyeSpot(66, 705, 224, 27, 29, 465, 35, 0xFF8EC3C3),
  'sternschnuppe': EyeSpot(158, 609, 290, 52, 58, 340, -45, 0xFF506276),
  'wellenwal': EyeSpot(173, 428, 392, 46, 56, 330, 125, 0xFF8CCAC6),
  'wolkenwuff': EyeSpot(146, 375, 376, 44, 66, 480, 10, 0xFFF0F2F4),
  'wolkenwuff2': EyeSpot(62, 885, 658, 20, 20, 440, 130, 0xFFCBDAED),
  'wolkenwuff3': EyeSpot(76, 544, 443, 22, 22, 520, 200, 0xFF88C6E0),
  'zapfi': EyeSpot(147, 499, 335, 46, 67, 495, 25, 0xFFE9B99A),
  'zapfi2': EyeSpot(85, 571, 225, 40, 46, 300, 70, 0xFFCE9668),
  'zapfi3': EyeSpot(83, 695, 380, 30, 28, 310, 100, 0xFFBFA47A),
};
