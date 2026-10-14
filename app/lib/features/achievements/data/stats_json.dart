import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/achievements/domain/lifetime_stats.dart';

/// Zahlen fürs Erfolge-Buch als JSON, mit Namen statt Nummern, damit neue
/// Umgebungen oder Wetter nichts verschieben.
Map<String, dynamic> statsToJson(LifetimeStats s) => {
  'meters': s.meters,
  'walks': s.walks,
  'longest': s.longest,
  'streets': {for (final e in s.streets.entries) e.key.name: e.value},
  'weather': {for (final e in s.weather.entries) e.key.name: e.value},
  'early': s.early,
  'evening': s.evening,
  'weekdays': s.weekdays.toList()..sort(),
  'bestLevel': s.bestLevel,
};

LifetimeStats statsFromJson(Map<String, dynamic> json) => LifetimeStats(
  meters: json['meters'] as int? ?? 0,
  walks: json['walks'] as int? ?? 0,
  longest: json['longest'] as int? ?? 0,
  streets: _named(EnvironmentType.values, json['streets']),
  weather: _named(BadWeather.values, json['weather']),
  early: json['early'] as int? ?? 0,
  evening: json['evening'] as int? ?? 0,
  weekdays: {
    for (final d in json['weekdays'] as List<dynamic>? ?? []) d as int,
  },
  bestLevel: json['bestLevel'] as int? ?? 0,
);

Map<T, int> _named<T extends Enum>(List<T> values, Object? raw) {
  final map = raw as Map<String, dynamic>? ?? const {};
  return {
    for (final v in values)
      if (map[v.name] case final int count) v: count,
  };
}
