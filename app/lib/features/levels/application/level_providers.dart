import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show StreamProviderFamily;
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/levels/domain/progress.dart';
import 'package:wandoo/features/levels/domain/progress_repository.dart';
import 'package:wandoo/features/levels/domain/stage_album_repository.dart';

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

/// Wird in `bootstrap/providers.dart` mit einer Umsetzung belegt.
final stageAlbumRepositoryProvider = Provider<StageAlbumRepository>(
  (ref) => throw UnimplementedError('In bootstrap/providers.dart setzen.'),
);

final _storedStagesProvider = StreamProvider<Map<String, int>>(
  (ref) => ref.watch(stageAlbumRepositoryProvider).watch(),
);

/// Art → höchste erreichte Stufe, samt der Stufe des aktuellen Wesens.
/// Belegt `reachedStagesProvider` fürs Sammelalbum.
final liveReachedStagesProvider = Provider<Map<String, int>>((ref) {
  final stored = ref.watch(_storedStagesProvider).value ?? const {};
  final species = ref.watch(creatureProvider).value?.speciesId;
  final stage = ref.watch(evolutionStageProvider) ?? 1;
  if (species == null || stage <= (stored[species] ?? 1)) return stored;
  return {...stored, species: stage};
});
