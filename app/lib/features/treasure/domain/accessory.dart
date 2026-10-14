import 'package:wandoo/features/treasure/domain/find.dart';

/// Wo das Wesen ein Deko-Teil trägt.
enum AccessorySlot { hat, neck }

/// Wie schwer ein Teil zu bekommen ist.
enum CraftTier { simple, medium, rare }

/// Deko fürs Wesen, gebastelt aus Fundstücken. Seltene Teile brauchen
/// zuerst einen Bauplan, den es bei Level-Aufstiegen gibt.
///
/// Neue Teile nur hinten anhängen: Die Namen stehen in der Datenbank.
enum Accessory {
  acornCap(AccessorySlot.hat, {Find.acorn: 3}),
  flowerCrown(AccessorySlot.hat, {Find.poppy: 4}),
  starCrown(AccessorySlot.hat, {Find.starShard: 3}, plan: true),
  shellNecklace(AccessorySlot.neck, {Find.shell: 4}),
  sparkleScarf(AccessorySlot.neck, {Find.sparkle: 3}),
  bow(AccessorySlot.hat, {Find.poppy: 3, Find.shell: 2}),
  acornChain(AccessorySlot.neck, {Find.acorn: 5}),
  flowerLei(AccessorySlot.neck, {Find.poppy: 6}),
  bowTie(AccessorySlot.neck, {Find.sparkle: 3, Find.poppy: 2}),
  mushroomCap(AccessorySlot.hat, {Find.acorn: 6, Find.poppy: 3}),
  strawHat(AccessorySlot.hat, {Find.poppy: 7, Find.acorn: 3}),
  sailorCap(AccessorySlot.hat, {Find.shell: 6, Find.sparkle: 3}),
  partyHat(AccessorySlot.hat, {Find.sparkle: 5, Find.poppy: 4}),
  bell(AccessorySlot.neck, {Find.sparkle: 5, Find.shell: 3}),
  knitScarf(AccessorySlot.neck, {Find.poppy: 6, Find.acorn: 5}, plan: true),
  bunnyEars(AccessorySlot.hat, {Find.poppy: 8, Find.shell: 5}, plan: true),
  antlers(AccessorySlot.hat, {Find.acorn: 10, Find.poppy: 4}, plan: true),
  pearlNecklace(AccessorySlot.neck, {
    Find.shell: 10,
    Find.starShard: 1,
  }, plan: true),
  topHat(AccessorySlot.hat, {Find.sparkle: 10, Find.starShard: 1}, plan: true),
  medal(AccessorySlot.neck, {Find.sparkle: 6, Find.starShard: 2}, plan: true),
  wizardHat(AccessorySlot.hat, {
    Find.sparkle: 12,
    Find.starShard: 2,
  }, plan: true),
  cape(AccessorySlot.neck, {Find.sparkle: 10, Find.poppy: 8}, plan: true),
  starHalo(AccessorySlot.hat, {Find.starShard: 5}, plan: true);

  const Accessory(this.slot, this.recipe, {this.plan = false});

  final AccessorySlot slot;

  /// Woraus es gebastelt wird und wie viele davon.
  final Map<Find, int> recipe;

  /// Braucht zuerst einen Bauplan.
  final bool plan;

  CraftTier get tier => plan
      ? CraftTier.rare
      : recipe.length > 1
      ? CraftTier.medium
      : CraftTier.simple;
}
