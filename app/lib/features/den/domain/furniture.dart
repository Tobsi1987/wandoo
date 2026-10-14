import 'package:wandoo/features/treasure/treasure.dart';

/// Die Plätze im Zuhause. Auf jedem steht höchstens ein Möbelstück.
enum Spot { wall, lamp, bed, plant, rug, toy }

/// Möbel fürs Zuhause, gebaut aus Fundstücken. Je Platz drei zur Wahl.
///
/// Neue Möbel nur hinten anhängen: Die Namen werden gespeichert.
enum Furniture {
  leafWreath(Spot.wall, {Find.acorn: 4}),
  shellGarland(Spot.wall, {Find.shell: 4, Find.poppy: 2}),
  starPicture(Spot.wall, {Find.sparkle: 4, Find.starShard: 1}),
  glowJar(Spot.lamp, {Find.sparkle: 3}),
  mushroomLamp(Spot.lamp, {Find.acorn: 3, Find.poppy: 3}),
  moonLamp(Spot.lamp, {Find.shell: 3, Find.starShard: 2}),
  hayNest(Spot.bed, {Find.poppy: 4, Find.acorn: 2}),
  shellBed(Spot.bed, {Find.shell: 6, Find.poppy: 3}),
  cloudBed(Spot.bed, {Find.sparkle: 6, Find.starShard: 2}),
  flowerPot(Spot.plant, {Find.poppy: 3}),
  fern(Spot.plant, {Find.acorn: 5}),
  waterLily(Spot.plant, {Find.shell: 4, Find.poppy: 3}),
  flowerRug(Spot.rug, {Find.poppy: 5}),
  waveRug(Spot.rug, {Find.shell: 5}),
  starRug(Spot.rug, {Find.sparkle: 5, Find.starShard: 1}),
  ball(Spot.toy, {Find.poppy: 2, Find.sparkle: 2}),
  spinningTop(Spot.toy, {Find.acorn: 4, Find.sparkle: 2}),
  toyBoat(Spot.toy, {Find.shell: 4, Find.acorn: 3});

  const Furniture(this.spot, this.recipe);

  final Spot spot;
  final Map<Find, int> recipe;

  static List<Furniture> at(Spot spot) => [
    for (final f in values)
      if (f.spot == spot) f,
  ];
}
