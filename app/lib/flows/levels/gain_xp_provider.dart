import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/den/den.dart';
import 'package:wandoo/features/levels/levels.dart';
import 'package:wandoo/features/treasure/treasure.dart';
import 'package:wandoo/flows/levels/gain_xp.dart';

final gainXpProvider = Provider<GainXp>(
  (ref) => GainXp(
    levels: ref.watch(progressRepositoryProvider),
    chests: ref.watch(treasureRepositoryProvider),
    boost: () {
      final room = ref.read(roomProvider).value ?? const DenRoom();
      return 1 + room.percent(Perk.xp) / 100;
    },
  ),
);
