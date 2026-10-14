import 'package:wandoo/features/friends/domain/friend.dart';
import 'package:wandoo/features/friends/domain/my_week.dart';

/// Speichert Freunde, die eigene Woche und die eigene zufällige Kennung.
abstract interface class FriendsRepository {
  Stream<List<Friend>> watchFriends();

  Future<void> saveFriends(List<Friend> friends);

  Stream<MyWeek> watchWeek();

  Future<MyWeek> loadWeek();

  Future<void> saveWeek(MyWeek week);

  /// Die eigene Kennung; beim ersten Mal wird sie zufällig erzeugt.
  Future<String> playerId();
}
