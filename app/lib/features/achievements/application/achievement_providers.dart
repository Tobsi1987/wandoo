import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/achievements/domain/achievement.dart';
import 'package:wandoo/features/achievements/domain/lifetime_stats.dart';
import 'package:wandoo/features/achievements/domain/stats_repository.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/levels/levels.dart';

/// Wird in `bootstrap/providers.dart` mit einer Umsetzung belegt.
final statsRepositoryProvider = Provider<StatsRepository>(
  (ref) => throw UnimplementedError('In bootstrap/providers.dart setzen.'),
);

final lifetimeStatsProvider = StreamProvider<LifetimeStats>(
  (ref) => ref.watch(statsRepositoryProvider).watch(),
);

/// Woraus das Buch gerade seine Stempel berechnet.
final achievementInputsProvider = Provider<AchievementInputs>((ref) {
  final creature = ref.watch(creatureProvider).value;
  final stats = ref.watch(lifetimeStatsProvider).value ?? const LifetimeStats();
  final level = ref.watch(progressProvider)?.level ?? 0;
  return AchievementInputs(
    stats: stats,
    speciesSeen: creature?.discoveredSpecies.length ?? 0,
    level: math.max(level, stats.bestLevel),
  );
});
