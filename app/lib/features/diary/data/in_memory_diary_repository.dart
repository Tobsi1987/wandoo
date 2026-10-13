import 'dart:async';

import 'package:wandoo/features/diary/domain/diary.dart';
import 'package:wandoo/features/diary/domain/diary_repository.dart';

/// Tagebücher nur im Speicher, für Tests und die Demo.
class InMemoryDiaryRepository implements DiaryRepository {
  final _walks = <DiaryWalk>[];
  final _memories = <Memory>[];
  final _changes = StreamController<void>.broadcast();

  @override
  Future<void> add(DiaryWalk walk, List<Memory> memories) async {
    _walks
      ..removeWhere((w) => w.walkId == walk.walkId)
      ..add(walk);
    _memories.addAll(memories);
    _changes.add(null);
  }

  @override
  Future<Diary> load(String creatureKey) async => _diary(creatureKey);

  @override
  Stream<Diary> watch(String creatureKey) async* {
    yield _diary(creatureKey);
    yield* _changes.stream.map((_) => _diary(creatureKey));
  }

  Diary _diary(String key) => Diary(
    walks: [..._walks.where((w) => w.creatureKey == key)]
      ..sort((a, b) => a.finishedAt.compareTo(b.finishedAt)),
    memories: [..._memories.where((m) => m.creatureKey == key)]
      ..sort((a, b) => a.at.compareTo(b.at)),
  );
}
