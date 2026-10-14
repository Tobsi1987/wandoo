import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/treasure/domain/accessory.dart';
import 'package:wandoo/features/treasure/domain/treasure_chest.dart';
import 'package:wandoo/features/treasure/domain/treasure_repository.dart';

/// Wird in `bootstrap/providers.dart` mit einer Umsetzung belegt.
final treasureRepositoryProvider = Provider<TreasureRepository>(
  (ref) => throw UnimplementedError('In bootstrap/providers.dart setzen.'),
);

final treasureChestProvider = StreamProvider<TreasureChest>(
  (ref) => ref.watch(treasureRepositoryProvider).watch(),
);

final treasureActionsProvider = Provider<TreasureActions>(
  (ref) => TreasureActions(
    ref.watch(treasureRepositoryProvider),
    ref.watch(creatureRepositoryProvider),
  ),
);

/// Basteln und Anziehen.
class TreasureActions {
  const TreasureActions(this._chests, this._creatures);

  final TreasureRepository _chests;
  final CreatureRepository _creatures;

  Future<void> craft(Accessory a) async {
    final chest = await _chests.load();
    await _chests.save(chest.craft(a));
  }

  /// Zieht [a] an; trägt das Wesen es schon, zieht es ihn aus.
  Future<void> toggleWear(Accessory a) async {
    final c = await _creatures.load();
    final hat = hatFor(a);
    final neck = neckFor(a);
    await _creatures.save(
      c.wearing(
        hat: a.slot == AccessorySlot.hat ? (c.hat == hat ? null : hat) : c.hat,
        neck: a.slot == AccessorySlot.neck
            ? (c.neck == neck ? null : neck)
            : c.neck,
      ),
    );
  }
}

/// Wie ein Deko-Teil am Wesen heißt: gleicher Name wie in [CreatureHat]
/// und [CreatureNeck].
CreatureHat? hatFor(Accessory a) =>
    a.slot == AccessorySlot.hat ? CreatureHat.values.asNameMap()[a.name] : null;

CreatureNeck? neckFor(Accessory a) => a.slot == AccessorySlot.neck
    ? CreatureNeck.values.asNameMap()[a.name]
    : null;
