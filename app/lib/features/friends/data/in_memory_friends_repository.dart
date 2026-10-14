import 'package:wandoo/core/memory/memory_value.dart';
import 'package:wandoo/features/friends/domain/friend.dart';
import 'package:wandoo/features/friends/domain/friends_repository.dart';
import 'package:wandoo/features/friends/domain/my_week.dart';

/// Freunde und Woche nur im Speicher, für Demo und Tests.
class InMemoryFriendsRepository implements FriendsRepository {
  InMemoryFriendsRepository({
    List<Friend> friends = const [],
    MyWeek week = const MyWeek(),
    this.id = 'ich',
  }) : _friends = MemoryValue(friends),
       _week = MemoryValue(week);

  final MemoryValue<List<Friend>> _friends;
  final MemoryValue<MyWeek> _week;
  final String id;

  List<Friend> get friends => _friends.current;

  @override
  Stream<List<Friend>> watchFriends() => _friends.watch();

  @override
  Future<void> saveFriends(List<Friend> friends) => _friends.save(friends);

  @override
  Stream<MyWeek> watchWeek() => _week.watch();

  @override
  Future<MyWeek> loadWeek() => _week.load();

  @override
  Future<void> saveWeek(MyWeek week) => _week.save(week);

  @override
  Future<String> playerId() async => id;
}
