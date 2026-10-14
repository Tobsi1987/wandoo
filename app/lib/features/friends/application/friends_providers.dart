import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/friends/domain/friend.dart';
import 'package:wandoo/features/friends/domain/friend_card.dart';
import 'package:wandoo/features/friends/domain/friends_repository.dart';
import 'package:wandoo/features/friends/domain/my_week.dart';

/// Wird in `bootstrap/providers.dart` mit einer Umsetzung belegt.
final friendsRepositoryProvider = Provider<FriendsRepository>(
  (ref) => throw UnimplementedError('In bootstrap/providers.dart setzen.'),
);

final _friendsProvider = StreamProvider<List<Friend>>(
  (ref) => ref.watch(friendsRepositoryProvider).watchFriends(),
);

final friendsProvider = Provider<List<Friend>>(
  (ref) => ref.watch(_friendsProvider).value ?? const [],
);

final _weekProvider = StreamProvider<MyWeek>(
  (ref) => ref.watch(friendsRepositoryProvider).watchWeek(),
);

/// Was du diese Woche gelaufen bist.
final myWeekProvider = Provider<MyWeek>(
  (ref) =>
      (ref.watch(_weekProvider).value ?? const MyWeek()).at(DateTime.now()),
);

/// Deine Karte, wie sie im QR-Code steht. Sie braucht Wesen, Level und
/// Erfolge, darum baut sie `flows/friends`; der Bootstrap hängt sie ein.
final myCardProvider = Provider<FriendCard?>(
  (ref) => throw UnimplementedError('In bootstrap/providers.dart setzen.'),
);

/// Nimmt einen Freund auf oder frischt seinen Stand auf (gleiche Kennung).
final addFriendProvider =
    Provider<Future<void> Function(FriendCard card, String name)>(
      (ref) => (card, name) async {
        final repo = ref.read(friendsRepositoryProvider);
        final others = [
          for (final f in ref.read(friendsProvider))
            if (f.card.player != card.player) f,
        ];
        await repo.saveFriends([...others, Friend(name: name, card: card)]);
      },
    );

final removeFriendProvider = Provider<Future<void> Function(Friend friend)>(
  (ref) =>
      (friend) => ref.read(friendsRepositoryProvider).saveFriends([
        for (final f in ref.read(friendsProvider))
          if (f.card.player != friend.card.player) f,
      ]),
);
