import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show StreamProviderFamily;
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/levels/domain/progress.dart';
import 'package:wandoo/features/levels/domain/progress_repository.dart';

/// Wird in `bootstrap/providers.dart` mit einer Umsetzung belegt.
final progressRepositoryProvider = Provider<ProgressRepository>(
  (ref) => throw UnimplementedError('In bootstrap/providers.dart setzen.'),
);

final StreamProviderFamily<Progress, String> _storedProgressProvider =
    StreamProvider.family<Progress, String>(
      (ref, lineKey) => ref.watch(progressRepositoryProvider).watch(lineKey),
    );

/// Die Erfahrung des aktuellen Wesens; null für ein Ei.
final progressProvider = Provider<Progress?>((ref) {
  final creature = ref.watch(creatureProvider).value;
  if (creature == null || !creature.hatched) return null;
  final key = creature.lineKey;
  return ref.watch(_storedProgressProvider(key)).value ??
      Progress(lineKey: key);
});

/// Die Entwicklungsstufe des aktuellen Wesens; null, solange sie lädt.
/// So entwickelt es sich beim Start nicht scheinbar von Stufe 1 aus.
final evolutionStageProvider = Provider<int?>((ref) {
  final creature = ref.watch(creatureProvider).value;
  if (creature == null || !creature.hatched) return 1;
  final stored = ref.watch(_storedProgressProvider(creature.lineKey));
  return stored.hasValue ? stored.value!.stage : null;
});
