import 'package:meta/meta.dart';
import 'package:wandoo/features/friends/domain/friend.dart';
import 'package:wandoo/features/friends/domain/friend_card.dart';

/// Wonach die Bestenliste sortiert.
enum Ranking {
  weekKm('Woche', 'km diese Woche'),
  weekStreets('Neue Straßen', 'neue Straßen diese Woche'),
  streets('Straßen', 'Straßen insgesamt'),
  kinds('Arten', 'Arten im Album');

  const Ranking(this.label, this.unit);

  final String label;
  final String unit;

  /// Der Wert einer Karte; Wochenwerte zählen nur in derselben Woche.
  int valueOf(FriendCard card, String week) => switch (this) {
    weekKm => card.week == week ? card.weekMeters : 0,
    weekStreets => card.week == week ? card.weekStreets : 0,
    streets => card.streets,
    kinds => card.kinds,
  };
}

/// Eine Zeile der Bestenliste.
@immutable
class LeaderRow {
  const LeaderRow({
    required this.place,
    required this.name,
    required this.card,
    required this.value,
    this.me = false,
  });

  final int place;
  final String name;
  final FriendCard card;
  final int value;
  final bool me;
}

/// Du und deine Freunde, nach [ranking] sortiert. Gleiche Werte teilen sich
/// einen Platz, und du stehst bei Gleichstand vorne.
List<LeaderRow> rank(
  Ranking ranking, {
  required FriendCard me,
  required List<Friend> friends,
  required String week,
}) {
  final rows = [
    (name: 'Du', card: me, me: true),
    for (final f in friends) (name: f.name, card: f.card, me: false),
  ];
  int value(({String name, FriendCard card, bool me}) r) =>
      ranking.valueOf(r.card, week);
  rows.sort((a, b) {
    final byValue = value(b).compareTo(value(a));
    if (byValue != 0) return byValue;
    return (a.me ? 0 : 1).compareTo(b.me ? 0 : 1);
  });
  final out = <LeaderRow>[];
  for (final (i, r) in rows.indexed) {
    final tie = i > 0 && value(rows[i - 1]) == value(r);
    out.add(
      LeaderRow(
        place: tie ? out.last.place : i + 1,
        name: r.name,
        card: r.card,
        value: value(r),
        me: r.me,
      ),
    );
  }
  return out;
}
