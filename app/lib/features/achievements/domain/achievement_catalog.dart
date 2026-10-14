import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/achievements/domain/achievement.dart';
import 'package:wandoo/features/achievements/domain/lifetime_stats.dart';

/// Alle Seiten des Erfolge-Buchs.
abstract final class AchievementCatalog {
  static final pages = [
    AchievementPage('Unterwegs', [
      Achievement(
        id: 'km',
        emoji: '👣',
        title: 'Wanderer',
        what: 'Kilometer gelaufen',
        steps: const [5, 25, 100],
        value: (i) => i.stats.meters ~/ 1000,
      ),
      Achievement(
        id: 'walks',
        emoji: '🚶',
        title: 'Ausflügler',
        what: 'Gänge gemacht',
        steps: const [5, 25, 100],
        value: (i) => i.stats.walks,
      ),
      Achievement(
        id: 'longest',
        emoji: '🏞️',
        title: 'Langer Atem',
        what: 'Meter am Stück',
        steps: const [2000, 5000, 10000],
        value: (i) => i.stats.longest,
      ),
      Achievement(
        id: 'streets',
        emoji: '🗺️',
        title: 'Entdecker',
        what: 'neue Wege entdeckt',
        steps: const [25, 150, 500],
        value: (i) => i.stats.newStreets,
      ),
    ]),
    AchievementPage('Umgebungen', [
      _place('forest', '🌲', 'Waldläufer', 'Waldwege', EnvironmentType.forest),
      _place('field', '🌾', 'Feldforscher', 'Feldwege', EnvironmentType.field),
      _place(
        'water',
        '🌊',
        'Wasserfreund',
        'Wege am Wasser',
        EnvironmentType.water,
      ),
      _place(
        'city',
        '🏘️',
        'Stadtkind',
        'Straßen in der Stadt',
        EnvironmentType.city,
      ),
    ]),
    AchievementPage('Wetter und Zeit', [
      _weather('rain', '☔', 'Regenheld', 'Gänge im Regen', BadWeather.rain),
      _weather(
        'snow',
        '❄️',
        'Schneestapfer',
        'Gänge im Schnee',
        BadWeather.snow,
      ),
      _weather(
        'storm',
        '⛈️',
        'Gewitter-Mut',
        'Gänge bei Gewitter',
        BadWeather.storm,
      ),
      Achievement(
        id: 'early',
        emoji: '🌅',
        title: 'Frühaufsteher',
        what: 'Gänge vor 8 Uhr',
        steps: const [1, 5, 20],
        value: (i) => i.stats.early,
      ),
      Achievement(
        id: 'evening',
        emoji: '🌙',
        title: 'Abendrunde',
        what: 'Gänge ab 19 Uhr',
        steps: const [1, 5, 20],
        value: (i) => i.stats.evening,
      ),
      Achievement(
        id: 'weekdays',
        emoji: '📅',
        title: 'Die ganze Woche',
        what: 'verschiedene Wochentage',
        steps: const [3, 5, 7],
        value: (i) => i.stats.weekdays.length,
      ),
    ]),
    AchievementPage('Wesen', [
      Achievement(
        id: 'species',
        emoji: '📒',
        title: 'Sammler',
        what: 'Arten gesehen',
        steps: const [3, 10, 20],
        value: (i) => i.speciesSeen,
      ),
      Achievement(
        id: 'level',
        emoji: '⭐',
        title: 'Großgeworden',
        what: 'Level erreicht',
        steps: const [5, 15, 30],
        value: (i) => i.level,
      ),
    ]),
  ];

  static Iterable<Achievement> get all =>
      pages.expand((page) => page.achievements);

  static Achievement _place(
    String id,
    String emoji,
    String title,
    String what,
    EnvironmentType type,
  ) => Achievement(
    id: id,
    emoji: emoji,
    title: title,
    what: 'neue $what',
    steps: const [10, 50, 150],
    value: (i) => i.stats.streets[type] ?? 0,
  );

  static Achievement _weather(
    String id,
    String emoji,
    String title,
    String what,
    BadWeather weather,
  ) => Achievement(
    id: id,
    emoji: emoji,
    title: title,
    what: what,
    steps: const [1, 5, 15],
    value: (i) => i.stats.weather[weather] ?? 0,
  );
}
