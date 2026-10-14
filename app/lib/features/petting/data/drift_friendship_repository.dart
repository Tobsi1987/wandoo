import 'package:drift/drift.dart';
import 'package:wandoo/core/database/app_database.dart';
import 'package:wandoo/features/petting/domain/friendship.dart';
import 'package:wandoo/features/petting/domain/friendship_repository.dart';

/// Speichert die Freundschaft in der lokalen Datenbank (eine Zeile).
class DriftFriendshipRepository implements FriendshipRepository {
  DriftFriendshipRepository(this._db);

  final AppDatabase _db;
  static const _rowId = 1;

  @override
  Future<Friendship> load(String creatureKey) async =>
      _toFriendship(creatureKey, await _query().getSingleOrNull());

  @override
  Stream<Friendship> watch(String creatureKey) => _query()
      .watchSingleOrNull()
      .map((row) => _toFriendship(creatureKey, row));

  @override
  Future<void> save(Friendship f) => _db
      .into(_db.friendshipStates)
      .insertOnConflictUpdate(
        FriendshipStatesCompanion.insert(
          id: const Value(_rowId),
          creatureKey: f.creatureKey,
          points: Value(f.points),
          petsToday: Value(f.petsToday),
          petDay: Value(f.petDay),
        ),
      );

  SimpleSelectStatement<$FriendshipStatesTable, FriendshipState> _query() =>
      _db.select(_db.friendshipStates)..where((t) => t.id.equals(_rowId));

  /// Gehört die Zeile zu einem weggeschickten Wesen, fängt es neu an.
  static Friendship _toFriendship(String key, FriendshipState? row) {
    if (row == null || row.creatureKey != key) {
      return Friendship(creatureKey: key);
    }
    return Friendship(
      creatureKey: key,
      points: row.points,
      petsToday: row.petsToday,
      petDay: row.petDay,
    );
  }
}
