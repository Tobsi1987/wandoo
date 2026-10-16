import 'package:wandoo/features/den/domain/den_room.dart';
import 'package:wandoo/features/den/domain/furniture.dart';

/// Was ein aufgestelltes Möbelstück dem Wesen bringt.
enum Perk {
  /// Mehr Erfahrung.
  xp,

  /// Der Hungerbalken wird langsamer leer.
  hunger,
}

extension FurniturePerk on Furniture {
  /// Wand, Licht und Spielzeug geben Erfahrung, Bett, Pflanze und
  /// Teppich lassen den Hunger langsamer wachsen.
  Perk get perk => switch (spot) {
    Spot.wall || Spot.lamp || Spot.toy => Perk.xp,
    Spot.bed || Spot.plant || Spot.rug => Perk.hunger,
  };

  /// Je teurer, desto stärker: 5, 10 oder 15 Prozent.
  int get percent => 5 * (Furniture.at(spot).indexOf(this) + 1);
}

extension RoomPerks on DenRoom {
  /// Summe der Prozente aller aufgestellten Möbel mit [perk].
  int percent(Perk perk) => placed.values
      .where((f) => f.perk == perk)
      .fold(0, (sum, f) => sum + f.percent);
}
