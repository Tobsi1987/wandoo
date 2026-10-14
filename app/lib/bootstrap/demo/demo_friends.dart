import 'package:wandoo/bootstrap/demo/demo_params.dart';
import 'package:wandoo/features/friends/friends.dart';

/// Drei erfundene Freunde für die Bestenliste; `?freunde=0` lässt sie weg.
List<Friend> demoFriends() {
  if (demoParams['freunde'] == '0') return const [];
  final now = DateTime.now();
  final week = weekOf(now);
  Friend friend(String name, String species, int level, List<int> n) => Friend(
    name: name,
    card: FriendCard(
      player: 'demo-$name',
      species: species,
      level: level,
      meters: n[0],
      streets: n[1],
      kinds: n[2],
      week: week,
      weekMeters: n[3],
      weekStreets: n[4],
      at: now.subtract(const Duration(days: 1)),
    ),
  );
  return [
    friend('Mia', 'funkel', 12, [41000, 380, 5, 6200, 41]),
    friend('Ben', 'moosel', 7, [18500, 160, 3, 2900, 12]),
    friend('Lena', 'glutling', 15, [63000, 520, 7, 1800, 4]),
  ];
}
