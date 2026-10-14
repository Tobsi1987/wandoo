import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart' as vm;
import 'package:wandoo/features/creature/domain/outfit.dart';
import 'package:wandoo/features/creature/presentation/model/model_anchors.dart';
import 'package:wandoo/features/creature/presentation/outfit/model_hats.dart';
import 'package:wandoo/features/creature/presentation/outfit/model_hats_fun.dart';
import 'package:wandoo/features/creature/presentation/outfit/model_hats_more.dart';
import 'package:wandoo/features/creature/presentation/outfit/model_necks.dart';
import 'package:wandoo/features/creature/presentation/outfit/model_necks_more.dart';
import 'package:wandoo/features/creature/presentation/outfit/model_weather_gear.dart';

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
  if (hat != null) _hats[hat]!(root, hatAt, at.headRadius);
  if (outfit.neck case final neck?) {
    _necks[neck]!(root, neckAt, at.neckRadius);
  }
  return root;
}

typedef _Build = void Function(Node root, vm.Vector3 at, double r);

const Map<CreatureHat, _Build> _hats = {
  CreatureHat.acornCap: acornCap,
  CreatureHat.flowerCrown: flowerCrown,
  CreatureHat.starCrown: starCrown,
  CreatureHat.bow: bow,
  CreatureHat.mushroomCap: mushroomCap,
  CreatureHat.strawHat: strawHat,
  CreatureHat.sailorCap: sailorCap,
  CreatureHat.partyHat: partyHat,
  CreatureHat.bunnyEars: bunnyEars,
  CreatureHat.antlers: antlers,
  CreatureHat.topHat: topHat,
  CreatureHat.wizardHat: wizardHat,
  CreatureHat.starHalo: starHalo,
};

const Map<CreatureNeck, _Build> _necks = {
  CreatureNeck.shellNecklace: shellNecklace,
  CreatureNeck.sparkleScarf: sparkleScarf,
  CreatureNeck.acornChain: acornChain,
  CreatureNeck.flowerLei: flowerLei,
  CreatureNeck.bowTie: bowTie,
  CreatureNeck.bell: bell,
  CreatureNeck.knitScarf: knitScarf,
  CreatureNeck.pearlNecklace: pearlNecklace,
  CreatureNeck.medal: medal,
  CreatureNeck.cape: cape,
};
