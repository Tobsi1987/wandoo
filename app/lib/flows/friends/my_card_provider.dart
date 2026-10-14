import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/achievements/achievements.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/friends/friends.dart';
import 'package:wandoo/features/levels/levels.dart';

final _playerIdProvider = FutureProvider<String>(
  (ref) => ref.watch(friendsRepositoryProvider).playerId(),
);

/// Deine Karte für Freunde, aus Wesen, Level, Erfolgen und dieser Woche.
/// Der Bootstrap hängt das in `myCardProvider` ein.
final liveMyCardProvider = Provider<FriendCard?>((ref) {
  final id = ref.watch(_playerIdProvider).value;
  if (id == null) return null;
  final creature = ref.watch(creatureProvider).value;
  final stats = ref.watch(lifetimeStatsProvider).value;
  final week = ref.watch(myWeekProvider);
  final hatched = creature?.hatched ?? false;
  return FriendCard(
    player: id,
    species: hatched ? creature?.speciesId ?? '' : '',
    level: ref.watch(progressProvider)?.level ?? 0,
    meters: stats?.meters ?? 0,
    streets: stats?.newStreets ?? 0,
    kinds: creature?.discoveredSpecies.length ?? 0,
    week: week.week,
    weekMeters: week.meters,
    weekStreets: week.streets,
    at: DateTime.now(),
  );
});
