import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/hunger/hunger.dart';
import 'package:wandoo/flows/hunger/check_hunger.dart';

final checkHungerProvider = Provider<CheckHunger>(
  (ref) => CheckHunger(
    creatures: ref.watch(creatureRepositoryProvider),
    bellies: ref.watch(bellyRepositoryProvider),
    clock: ref.watch(hungerClockProvider),
    drain: ref.watch(hungerDrainProvider),
  ),
);
