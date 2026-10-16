import 'package:wandoo/features/treasure/treasure.dart';

/// Die Plätze im Zuhause. Auf jedem steht höchstens ein Möbelstück.
enum Spot { wall, lamp, bed, plant, rug, toy }

/// Möbel fürs Zuhause, gebaut aus Fundstücken. Je Platz drei zur Wahl;
/// aufgestellt bringen sie Boni (siehe `furniture_perk.dart`).
///
/// Neue Möbel nur hinten anhängen: Die Namen werden gespeichert.
enum Furniture {
  leafWreath(Spot.wall, {Find.acorn: 6}),
  shellGarland(Spot.wall, {Find.shell: 6, Find.poppy: 3}),
  starPicture(Spot.wall, {Find.sparkle: 6, Find.starShard: 2}),
  glowJar(Spot.lamp, {Find.sparkle: 5}),
  mushroomLamp(Spot.lamp, {Find.acorn: 5, Find.poppy: 5}),
  moonLamp(Spot.lamp, {Find.shell: 5, Find.starShard: 3}),
  hayNest(Spot.bed, {Find.poppy: 6, Find.acorn: 3}),
  shellBed(Spot.bed, {Find.shell: 9, Find.poppy: 5}),
  cloudBed(Spot.bed, {Find.sparkle: 9, Find.starShard: 3}),
  flowerPot(Spot.plant, {Find.poppy: 5}),
  fern(Spot.plant, {Find.acorn: 8}),
  waterLily(Spot.plant, {Find.shell: 6, Find.poppy: 5}),
  flowerRug(Spot.rug, {Find.poppy: 8}),
  waveRug(Spot.rug, {Find.shell: 8}),
  starRug(Spot.rug, {Find.sparkle: 8, Find.starShard: 2}),
  ball(Spot.toy, {Find.poppy: 3, Find.sparkle: 3}),
  spinningTop(Spot.toy, {Find.acorn: 6, Find.sparkle: 3}),
  toyBoat(Spot.toy, {Find.shell: 6, Find.acorn: 5});

  const Furniture(this.spot, this.recipe);

  final Spot spot;
  final Map<Find, int> recipe;

  static List<Furniture> at(Spot spot) => [
    for (final f in values)
      if (f.spot == spot) f,
  ];
}
