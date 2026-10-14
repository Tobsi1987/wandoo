import 'package:geo_engine/geo_engine.dart';

/// Schlechtes Wetter, bei dem ein Gang besonders mutig ist.
enum BadWeather { rain, snow, storm }

/// Was ein einzelner Gang fürs Erfolge-Buch zählt.
class WalkFacts {
  const WalkFacts({
    required this.meters,
    required this.startedAt,
    this.newStreets = const {},
    this.weather,
  });

  final int meters;
  final DateTime startedAt;

  /// Neu entdeckte Abschnitte je Umgebung.
  final Map<EnvironmentType, int> newStreets;
  final BadWeather? weather;
}

/// Alles, was über alle Gänge und Wesen hinweg zusammenkommt.
class LifetimeStats {
  const LifetimeStats({
    this.meters = 0,
    this.walks = 0,
    this.longest = 0,
    this.streets = const {},
    this.weather = const {},
    this.early = 0,
    this.evening = 0,
    this.weekdays = const {},
    this.bestLevel = 0,
  });

  final int meters;
  final int walks;

  /// Der längste einzelne Gang, in Metern.
  final int longest;
  final Map<EnvironmentType, int> streets;
  final Map<BadWeather, int> weather;

  /// Gänge vor 8 Uhr und ab 19 Uhr.
  final int early;
  final int evening;

  /// An welchen Wochentagen schon gelaufen wurde (1 = Montag).
  final Set<int> weekdays;

  /// Das höchste Level, das je ein Wesen erreicht hat.
  final int bestLevel;

  int get newStreets => streets.values.fold(0, (a, b) => a + b);

  LifetimeStats add(WalkFacts walk) {
    final hour = walk.startedAt.hour;
    final w = walk.weather;
    final braved = w == null ? weather : {...weather, w: (weather[w] ?? 0) + 1};
    return LifetimeStats(
      meters: meters + walk.meters,
      walks: walks + 1,
      longest: walk.meters > longest ? walk.meters : longest,
      streets: {
        for (final type in {...streets.keys, ...walk.newStreets.keys})
          type: (streets[type] ?? 0) + (walk.newStreets[type] ?? 0),
      },
      weather: braved,
      early: early + (hour < 8 ? 1 : 0),
      evening: evening + (hour >= 19 ? 1 : 0),
      weekdays: {...weekdays, walk.startedAt.weekday},
      bestLevel: bestLevel,
    );
  }

  LifetimeStats withLevel(int level) => level <= bestLevel
      ? this
      : LifetimeStats(
          meters: meters,
          walks: walks,
          longest: longest,
          streets: streets,
          weather: weather,
          early: early,
          evening: evening,
          weekdays: weekdays,
          bestLevel: level,
        );
}
