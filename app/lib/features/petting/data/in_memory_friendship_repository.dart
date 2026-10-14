import 'dart:async';

import 'package:wandoo/features/petting/domain/friendship.dart';
import 'package:wandoo/features/petting/domain/friendship_repository.dart';

/// Freundschaft nur im Speicher, für Tests und die Demo.
class InMemoryFriendshipRepository implements FriendshipRepository {
  Friendship? _stored;
  final _changes = StreamController<Friendship>.broadcast();

  @override
  Future<Friendship> load(String creatureKey) async => _for(creatureKey);

  @override
  Future<void> save(Friendship friendship) async {
    _stored = friendship;
    _changes.add(friendship);
  }

  @override
  Stream<Friendship> watch(String creatureKey) async* {
    yield _for(creatureKey);
    yield* _changes.stream.map((_) => _for(creatureKey));
  }

  Friendship _for(String key) {
    final stored = _stored;
    if (stored == null || stored.creatureKey != key) {
      return Friendship(creatureKey: key);
    }
    return stored;
  }
}
