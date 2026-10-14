import 'dart:math' as math;

import 'package:wandoo/features/achievements/achievements.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/levels/levels.dart';
import 'package:wandoo/features/world/world.dart';
import 'package:wandoo/flows/process_walk/walk_extra.dart';

/// Zählt den Gang fürs Erfolge-Buch und meldet neue Stempel. Es gibt
/// nichts dafür, nur eine Zeile in der Zusammenfassung.
class AchievementExtra implements WalkExtra {
  AchievementExtra({
    required this.stats,
    required this.levels,
    required this.weather,
  });

  final StatsRepository stats;
  final ProgressRepository levels;

  /// Das Wetter jetzt, also direkt nach dem Gang.
  final Weather? Function() weather;

  @override
  Future<List<String>> onWalk(WalkOutcome outcome) async {
    final old = await stats.load();
    final level = await _level(outcome.after);
    final now = old
        .add(
          WalkFacts(
            meters: outcome.summary.distanceMeters,
            startedAt: outcome.track.startedAt ?? outcome.summary.finishedAt,
            newStreets: outcome.newSegmentsByEnvironment,
            weather: _bad(weather()),
          ),
        )
        .withLevel(level);
    await stats.save(now);
    return newStamps(
      _inputs(old, outcome.before, level: old.bestLevel),
      _inputs(now, outcome.after, level: level),
    );
  }

  Future<int> _level(Creature creature) async =>
      creature.hatched ? (await levels.load(creature.lineKey)).level : 0;

  static AchievementInputs _inputs(
    LifetimeStats stats,
    Creature creature, {
    required int level,
  }) => AchievementInputs(
    stats: stats,
    speciesSeen: creature.discoveredSpecies.length,
    level: math.max(level, stats.bestLevel),
  );

  static BadWeather? _bad(Weather? weather) => switch (weather) {
    Weather.rain => BadWeather.rain,
    Weather.snow => BadWeather.snow,
    Weather.storm => BadWeather.storm,
    _ => null,
  };
}
