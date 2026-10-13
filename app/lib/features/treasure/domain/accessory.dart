import 'package:wandoo/features/treasure/domain/find.dart';

/// Wo das Wesen ein Deko-Teil trägt.
enum AccessorySlot { hat, neck }

/// Deko fürs Wesen, gebastelt aus Fundstücken.
enum Accessory {
  acornCap(AccessorySlot.hat, Find.acorn, 3),
  flowerCrown(AccessorySlot.hat, Find.poppy, 4),
  starCrown(AccessorySlot.hat, Find.starShard, 1),
  shellNecklace(AccessorySlot.neck, Find.shell, 4),
  sparkleScarf(AccessorySlot.neck, Find.sparkle, 3);

  const Accessory(this.slot, this.material, this.cost);

  final AccessorySlot slot;

  /// Woraus es gebastelt wird und wie viele davon.
  final Find material;
  final int cost;
}
