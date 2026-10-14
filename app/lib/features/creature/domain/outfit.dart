import 'package:meta/meta.dart';

/// Was das Wesen auf dem Kopf trägt. Die Reihenfolge ist die Nummer im
/// Shader (+1, 0 heißt nichts) und darf sich nicht ändern.
enum CreatureHat {
  acornCap,
  flowerCrown,
  starCrown,
  bow,
  mushroomCap,
  strawHat,
  sailorCap,
  partyHat,
  bunnyEars,
  antlers,
  topHat,
  wizardHat,
  starHalo,
}

/// Was das Wesen um den Hals trägt. Reihenfolge wie bei [CreatureHat].
enum CreatureNeck {
  shellNecklace,
  sparkleScarf,
  acornChain,
  flowerLei,
  bowTie,
  bell,
  knitScarf,
  pearlNecklace,
  medal,
  cape,
}

/// Was das Wesen bei Wetter dabeihat: Bei Regen einen Schirm, bei Schnee
/// eine Mütze (die dann den Hut ersetzt).
enum WeatherGear { umbrella, beanie }

/// Alles, was das Wesen gerade an sich trägt.
@immutable
class Outfit {
  const Outfit({this.hat, this.neck, this.gear});

  final CreatureHat? hat;
  final CreatureNeck? neck;
  final WeatherGear? gear;

  bool get isEmpty => hat == null && neck == null && gear == null;

  @override
  bool operator ==(Object other) =>
      other is Outfit &&
      other.hat == hat &&
      other.neck == neck &&
      other.gear == gear;

  @override
  int get hashCode => Object.hash(hat, neck, gear);
}
