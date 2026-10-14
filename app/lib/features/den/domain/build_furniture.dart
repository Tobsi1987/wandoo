import 'package:wandoo/features/den/domain/furniture.dart';
import 'package:wandoo/features/den/domain/room_repository.dart';
import 'package:wandoo/features/treasure/treasure.dart';

/// Baut ein Möbelstück aus den Fundstücken der Schatzkiste und stellt es
/// gleich auf seinen Platz.
class BuildFurniture {
  BuildFurniture({required this.rooms, required this.treasure});

  final RoomRepository rooms;
  final TreasureRepository treasure;

  /// Ob es klappt; false, wenn es schon gebaut ist oder Fundstücke fehlen.
  Future<bool> call(Furniture f) async {
    final room = await rooms.load();
    final chest = await treasure.load();
    if (room.owned.contains(f) || !chest.canAfford(f.recipe)) return false;
    await treasure.save(chest.spend(f.recipe));
    await rooms.save(room.add(f));
    return true;
  }
}
