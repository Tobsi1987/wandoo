import 'package:meta/meta.dart';
import 'package:wandoo/features/friends/domain/friend_card.dart';

/// Ein Freund: der Name, den du ihm gibst, und sein letzter Stand.
@immutable
class Friend {
  const Friend({required this.name, required this.card});

  factory Friend.fromJson(Map<String, dynamic> json) => Friend(
    name: json['name'] as String,
    card: FriendCard.fromJson(json['card'] as Map<String, dynamic>),
  );

  final String name;
  final FriendCard card;

  Map<String, Object?> toJson() => {'name': name, 'card': card.toJson()};
}
