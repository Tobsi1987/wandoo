import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show StreamProviderFamily;
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/hunger/domain/belly.dart';
import 'package:wandoo/features/hunger/domain/belly_repository.dart';
import 'package:wandoo/features/hunger/domain/farewell.dart';

/// Wird in `bootstrap/providers.dart` mit einer Umsetzung belegt.
final bellyRepositoryProvider = Provider<BellyRepository>(
  (ref) => throw UnimplementedError('In bootstrap/providers.dart setzen.'),
);

/// Die Uhr für den Hunger; Tests und Demo stellen sie.
final hungerClockProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);

final StreamProviderFamily<Belly?, String> _bellyProvider =
    StreamProvider.family<Belly?, String>(
      (ref, lineKey) => ref.watch(bellyRepositoryProvider).watch(lineKey),
    );

final farewellProvider = StreamProvider<Farewell?>(
  (ref) => ref.watch(bellyRepositoryProvider).watchLetter(),
);

/// Der Balken des aktuellen Wesens; null für ein Ei. Ein frisch
/// geschlüpftes Wesen ist satt.
final currentBellyProvider = Provider<Belly?>((ref) {
  final creature = ref.watch(creatureProvider).value;
  if (creature == null || !creature.hatched) return null;
  final belly = ref.watch(_bellyProvider(creature.lineKey)).value;
  return belly ??
      Belly.full(creature.lineKey, ref.watch(hungerClockProvider)());
});

/// Ob das Wesen gerade hungrig ist (Balken leer): dann ist es müde und
/// traurig.
final starvingProvider = Provider<bool>(
  (ref) =>
      ref
          .watch(currentBellyProvider)
          ?.isEmpty(ref.watch(hungerClockProvider)()) ??
      false,
);
