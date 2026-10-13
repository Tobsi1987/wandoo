import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/diary/domain/diary.dart';
import 'package:wandoo/features/diary/domain/diary_repository.dart';
import 'package:wandoo/features/diary/domain/remember_walk.dart';

/// Wird in `bootstrap/providers.dart` mit einer Umsetzung belegt.
final diaryRepositoryProvider = Provider<DiaryRepository>(
  (ref) => throw UnimplementedError('In bootstrap/providers.dart setzen.'),
);

final rememberWalkProvider = Provider<RememberWalk>(
  (ref) => const RememberWalk(),
);

/// Das Tagebuch des aktuellen Wesens.
final diaryProvider = StreamProvider<Diary>((ref) {
  final key = ref.watch(creatureProvider.select((c) => c.value?.lineKey));
  if (key == null) return const Stream.empty();
  return ref.watch(diaryRepositoryProvider).watch(key);
});
