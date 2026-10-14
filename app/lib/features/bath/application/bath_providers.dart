import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show StreamProviderFamily;
import 'package:wandoo/features/bath/domain/mud_repository.dart';
import 'package:wandoo/features/creature/creature.dart';

/// Wird in `bootstrap/providers.dart` mit einer Umsetzung belegt.
final mudRepositoryProvider = Provider<MudRepository>(
  (ref) => throw UnimplementedError('In bootstrap/providers.dart setzen.'),
);

final StreamProviderFamily<int, String> _mudProvider =
    StreamProvider.family<int, String>(
      (ref, lineKey) => ref.watch(mudRepositoryProvider).watch(lineKey),
    );

/// Wie schmutzig das aktuelle Wesen ist; Eier werden nicht schmutzig.
final currentMudProvider = Provider<int>((ref) {
  final creature = ref.watch(creatureProvider).value;
  if (creature == null || !creature.hatched) return 0;
  return ref.watch(_mudProvider(creature.lineKey)).value ?? 0;
});
