import 'package:wandoo/features/petting/domain/friendship.dart';

/// Speichert die Freundschaft des aktuellen Wesens.
abstract interface class FriendshipRepository {
  /// Die Freundschaft zum Wesen [creatureKey]; für ein neues Wesen leer.
  Future<Friendship> load(String creatureKey);

  Future<void> save(Friendship friendship);

  Stream<Friendship> watch(String creatureKey);
}
