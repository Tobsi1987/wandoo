import 'package:meta/meta.dart';
import 'package:wandoo/features/friends/domain/friend_card.dart';

/// Was du diese Woche gelaufen bist. Am Montag fängt es neu an.
@immutable
class MyWeek {
  const MyWeek({this.week = '', this.meters = 0, this.streets = 0});

  factory MyWeek.fromJson(Map<String, dynamic> json) => MyWeek(
    week: json['week'] as String? ?? '',
    meters: json['meters'] as int? ?? 0,
    streets: json['streets'] as int? ?? 0,
  );

  final String week;
  final int meters;
  final int streets;

  /// Der Stand für die Woche von [now] (leer, wenn die alte vorbei ist).
  MyWeek at(DateTime now) =>
      week == weekOf(now) ? this : MyWeek(week: weekOf(now));

  MyWeek add({
    required int meters,
    required int streets,
    required DateTime now,
  }) {
    final base = at(now);
    return MyWeek(
      week: base.week,
      meters: base.meters + meters,
      streets: base.streets + streets,
    );
  }

  Map<String, Object?> toJson() => {
    'week': week,
    'meters': meters,
    'streets': streets,
  };
}
