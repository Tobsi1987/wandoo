import 'package:flutter_test/flutter_test.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/achievements/achievements.dart';
import 'package:wandoo/features/achievements/data/stats_json.dart';

void main() {
  final morning = DateTime(2026, 10, 14, 7, 30);

  test('ein Gang zählt Meter, Wege, Wetter, Uhrzeit und Wochentag', () {
    final stats = const LifetimeStats().add(
      WalkFacts(
        meters: 2400,
        startedAt: morning,
        newStreets: const {EnvironmentType.forest: 12},
        weather: BadWeather.rain,
      ),
    );
    expect(stats.meters, 2400);
    expect(stats.walks, 1);
    expect(stats.longest, 2400);
    expect(stats.streets[EnvironmentType.forest], 12);
    expect(stats.weather[BadWeather.rain], 1);
    expect(stats.early, 1);
    expect(stats.evening, 0);
    expect(stats.weekdays, {DateTime.wednesday});
  });

  test('Stufen: Bronze, Silber, Gold nach den Schwellen', () {
    final km = AchievementCatalog.all.firstWhere((a) => a.id == 'km');
    AchievementInputs walked(int meters) =>
        AchievementInputs(stats: LifetimeStats(meters: meters));
    expect(km.tierFor(walked(4999)), Tier.none);
    expect(km.tierFor(walked(5000)), Tier.bronze);
    expect(km.tierFor(walked(30000)), Tier.silver);
    expect(km.tierFor(walked(100000)), Tier.gold);
  });

  test('neue Stempel werden als Zeile gemeldet', () {
    const before = AchievementInputs();
    final after = AchievementInputs(
      stats: const LifetimeStats().add(
        WalkFacts(meters: 300, startedAt: morning, weather: BadWeather.snow),
      ),
    );
    final lines = newStamps(before, after);
    expect(lines, contains('📖 Neuer Stempel: ❄️ Schneestapfer in Bronze'));
    expect(lines, contains('📖 Neuer Stempel: 🌅 Frühaufsteher in Bronze'));
    expect(newStamps(after, after), isEmpty);
  });

  test('JSON hin und zurück', () {
    final stats = const LifetimeStats()
        .add(
          WalkFacts(
            meters: 900,
            startedAt: morning,
            newStreets: const {EnvironmentType.water: 3},
            weather: BadWeather.storm,
          ),
        )
        .withLevel(7);
    final back = statsFromJson(statsToJson(stats));
    expect(back.meters, 900);
    expect(back.streets, {EnvironmentType.water: 3});
    expect(back.weather, {BadWeather.storm: 1});
    expect(back.weekdays, stats.weekdays);
    expect(back.bestLevel, 7);
  });
}
