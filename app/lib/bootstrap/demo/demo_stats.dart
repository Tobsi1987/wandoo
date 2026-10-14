import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/bootstrap/demo/demo_params.dart';
import 'package:wandoo/features/achievements/achievements.dart';

/// Mit `?wesen=…` hat man in der Demo schon etwas erlebt, damit das
/// Erfolge-Buch nicht leer ist. Ohne fängt alles bei null an.
LifetimeStats demoStats() {
  if (!demoParams.containsKey('wesen')) {
    return const LifetimeStats();
  }
  return const LifetimeStats(
    meters: 31400,
    walks: 27,
    longest: 3200,
    streets: {
      EnvironmentType.forest: 64,
      EnvironmentType.field: 41,
      EnvironmentType.water: 12,
      EnvironmentType.city: 88,
    },
    weather: {BadWeather.rain: 6, BadWeather.snow: 1},
    early: 3,
    evening: 11,
    weekdays: {1, 3, 4, 6, 7},
  );
}
