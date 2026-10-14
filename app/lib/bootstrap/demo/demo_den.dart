import 'package:wandoo/features/den/den.dart';
import 'package:wandoo/features/treasure/treasure.dart';

// Mit `?wesen=…` ist das Zuhause schon ein bisschen eingerichtet und die
// Schatzkiste hat Fundstücke zum Bauen. `&zuhause=1|2|3` stellt eine der
// drei Möbelreihen hin (alle Möbel gehören einem dann).

bool get _started => Uri.base.queryParameters.containsKey('wesen');

DenRoom demoRoom() {
  final pick = int.tryParse(Uri.base.queryParameters['zuhause'] ?? '');
  if (pick != null && pick >= 1 && pick <= 3) {
    var room = const DenRoom(owned: {...Furniture.values});
    for (final spot in Spot.values) {
      room = room.put(Furniture.at(spot)[pick - 1]);
    }
    return room;
  }
  if (!_started) return const DenRoom();
  return const DenRoom().add(Furniture.hayNest).add(Furniture.flowerPot);
}

TreasureChest demoChest() => _started
    ? const TreasureChest(
        finds: {
          Find.acorn: 12,
          Find.shell: 10,
          Find.sparkle: 9,
          Find.poppy: 14,
          Find.starShard: 3,
        },
      )
    : const TreasureChest();
