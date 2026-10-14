import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/petting/domain/befriend_creature.dart';
import 'package:wandoo/features/petting/domain/friendship.dart';
import 'package:wandoo/features/petting/domain/friendship_repository.dart';

/// Wird in `bootstrap/providers.dart` mit einer Umsetzung belegt.
final friendshipRepositoryProvider = Provider<FriendshipRepository>(
  (ref) => throw UnimplementedError('In bootstrap/providers.dart setzen.'),
);

final befriendCreatureProvider = Provider<BefriendCreature>(
  (ref) => const BefriendCreature(),
);

/// Die Freundschaft zum aktuellen Wesen.
final friendshipProvider = StreamProvider<Friendship>((ref) {
  final key = ref.watch(creatureProvider.select((c) => c.value?.lineKey));
  if (key == null) return const Stream.empty();
  return ref.watch(friendshipRepositoryProvider).watch(key);
});

final petCreatureProvider = Provider<PetCreature>(
  (ref) => PetCreature(
    creatures: ref.watch(creatureRepositoryProvider),
    friendships: ref.watch(friendshipRepositoryProvider),
    rules: ref.watch(befriendCreatureProvider),
  ),
);

/// Streichelt das aktuelle Wesen. Eier lassen sich noch nicht streicheln.
class PetCreature {
  PetCreature({
    required this.creatures,
    required this.friendships,
    required this.rules,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final CreatureRepository creatures;
  final FriendshipRepository friendships;
  final BefriendCreature rules;
  final DateTime Function() _clock;

  /// Gibt zurück, ob ein neues Herz dazugekommen ist.
  Future<bool> call() async {
    final creature = await creatures.load();
    if (!creature.hatched) return false;
    final before = await friendships.load(creature.lineKey);
    final after = rules.pet(before, _clock());
    await friendships.save(after);
    return after.hearts > before.hearts;
  }
}
