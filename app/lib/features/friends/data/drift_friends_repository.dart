import 'package:wandoo/core/database/app_database.dart';
import 'package:wandoo/core/database/preference_store.dart';
import 'package:wandoo/features/friends/data/random_player_id.dart';
import 'package:wandoo/features/friends/domain/friend.dart';
import 'package:wandoo/features/friends/domain/friends_repository.dart';
import 'package:wandoo/features/friends/domain/my_week.dart';

/// Speichert Freunde und die eigene Woche in den Einstellungen.
class DriftFriendsRepository implements FriendsRepository {
  DriftFriendsRepository(AppDatabase db) : _store = PreferenceStore(db);

  final PreferenceStore _store;
  static const _friends = 'friends.list';
  static const _week = 'friends.week';
  static const _me = 'friends.me';

  @override
  Stream<List<Friend>> watchFriends() =>
      _store.watchJson(_friends).map(_readFriends);

  @override
  Future<void> saveFriends(List<Friend> friends) => _store.putJson(_friends, {
    'friends': [for (final f in friends) f.toJson()],
  });

  @override
  Stream<MyWeek> watchWeek() => _store.watchJson(_week).map(_readWeek);

  @override
  Future<MyWeek> loadWeek() async => _readWeek(await _store.getJson(_week));

  @override
  Future<void> saveWeek(MyWeek week) => _store.putJson(_week, week.toJson());

  @override
  Future<String> playerId() async {
    final known = await _store.get(_me);
    if (known != null) return known;
    final id = randomPlayerId();
    await _store.put(_me, id);
    return id;
  }

  static List<Friend> _readFriends(Map<String, dynamic>? json) => [
    for (final f in json?['friends'] as List<dynamic>? ?? const [])
      Friend.fromJson(f as Map<String, dynamic>),
  ];

  static MyWeek _readWeek(Map<String, dynamic>? json) =>
      json == null ? const MyWeek() : MyWeek.fromJson(json);
}
