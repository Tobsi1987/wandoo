import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/friends/domain/leaderboard.dart';
import 'package:wandoo/features/friends/friends.dart';

FriendCard _card(String id, {int weekMeters = 0, String week = '2026-10-12'}) =>
    FriendCard(
      player: id,
      week: week,
      weekMeters: weekMeters,
      at: DateTime(2026, 10, 14),
    );

void main() {
  test('Code hin und zurück, fremde Codes werden abgelehnt', () {
    final card = FriendCard(
      player: 'abc',
      species: 'moosel',
      level: 4,
      meters: 1200,
      streets: 30,
      kinds: 2,
      week: '2026-10-12',
      weekMeters: 800,
      weekStreets: 5,
      at: DateTime(2026, 10, 14, 9),
    );
    final back = FriendCard.decode(card.encode())!;
    expect(back.toJson(), card.toJson());
    expect(FriendCard.decode('https://example.com'), isNull);
    expect(FriendCard.decode('wandoo:1:kaputt'), isNull);
  });

  test('Woche fängt am Montag neu an', () {
    expect(weekOf(DateTime(2026, 10, 18)), '2026-10-12');
    final week = const MyWeek().add(
      meters: 500,
      streets: 3,
      now: DateTime(2026, 10, 14),
    );
    final next = week.add(meters: 100, streets: 1, now: DateTime(2026, 10, 19));
    expect(next.meters, 100);
    expect(week.at(DateTime(2026, 10, 20)).meters, 0);
  });

  test('Bestenliste: Gleichstand teilt den Platz, alte Wochen zählen 0', () {
    final rows = rank(
      Ranking.weekKm,
      me: _card('ich', weekMeters: 900),
      friends: [
        Friend(name: 'Mia', card: _card('m', weekMeters: 900)),
        Friend(
          name: 'Ben',
          card: _card('b', weekMeters: 5000, week: 'alt'),
        ),
        Friend(name: 'Lia', card: _card('l', weekMeters: 1500)),
      ],
      week: '2026-10-12',
    );
    expect([for (final r in rows) r.name], ['Lia', 'Du', 'Mia', 'Ben']);
    expect([for (final r in rows) r.place], [1, 2, 2, 4]);
  });
}
