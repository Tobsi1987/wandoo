import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/hunger/hunger.dart';
import 'package:wandoo/features/levels/levels.dart';

/// Die Höhle gibt es ab Level 25 (Stufe 3), danach für immer.
final denUnlockedProvider = Provider<bool>((ref) {
  if (ref.watch(sleeperProvider).value != null) return true;
  final level = ref.watch(progressProvider)?.level ?? 0;
  return level >= LevelCurve.stage3At;
});

final swapCreaturesProvider = Provider<SwapCreatures>(
  (ref) => SwapCreatures(
    creatures: ref.watch(creatureRepositoryProvider),
    den: ref.watch(denRepositoryProvider),
    bellies: ref.watch(bellyRepositoryProvider),
    clock: ref.watch(hungerClockProvider),
  ),
);

/// Schickt das aktive Wesen in den Winterschlaf: beim ersten Mal kommt ein
/// neues Ei dazu, danach wird getauscht. Im Winterschlaf wird der Bauch
/// nicht leerer.
class SwapCreatures {
  SwapCreatures({
    required this.creatures,
    required this.den,
    required this.bellies,
    required this.clock,
  });

  final CreatureRepository creatures;
  final DenRepository den;
  final BellyRepository bellies;
  final DateTime Function() clock;

  /// Das aktive Wesen schläft ein, ein neues Ei kommt.
  Future<void> takeSecondEgg() async {
    if (await den.load() != null) return;
    final now = clock();
    final active = await creatures.load();
    await den.save(Sleeper(creature: active, since: now));
    await creatures.save(
      Creature(
        lastReleasedAt: now,
        seenSpecies: active.seenSpecies,
        luckyEgg: active.luckyEgg,
      ),
    );
  }

  /// Weckt das schlafende Wesen, das aktive schläft dafür ein.
  Future<void> swap() async {
    final sleeper = await den.load();
    if (sleeper == null) return;
    final now = clock();
    final active = await creatures.load();
    final woken = sleeper.creature.copyWith(
      seenSpecies: {...sleeper.creature.seenSpecies, ...active.seenSpecies},
    );
    final belly = await bellies.load(woken.lineKey);
    if (belly != null) {
      await bellies.save(
        Belly(
          lineKey: belly.lineKey,
          meters: belly.metersAt(sleeper.since),
          at: now,
        ),
      );
    }
    await den.save(Sleeper(creature: active, since: now));
    await creatures.save(woken);
  }
}
