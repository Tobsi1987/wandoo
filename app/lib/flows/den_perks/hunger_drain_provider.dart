import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/den/den.dart';

/// Wie schnell der Hungerbalken leerer wird: Möbel mit dem Bonus
/// „langsamer hungrig" in der Höhle senken das. Belegt
/// `hungerDrainProvider` in `bootstrap/providers.dart`.
final liveHungerDrainProvider = Provider<double>((ref) {
  final room = ref.watch(roomProvider).value ?? const DenRoom();
  return 1 - room.percent(Perk.hunger) / 100;
});
