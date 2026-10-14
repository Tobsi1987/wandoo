import 'dart:async';

import 'package:wandoo/features/levels/domain/progress.dart';
import 'package:wandoo/features/levels/domain/progress_repository.dart';

/// Für Tests und die Demo.
class InMemoryProgressRepository implements ProgressRepository {
  InMemoryProgressRepository([Iterable<Progress> start = const []])
    : _all = {for (final p in start) p.lineKey: p};

  final Map<String, Progress> _all;
  final _changes = StreamController<Progress>.broadcast();

  @override
  Future<Progress> load(String lineKey) async =>
      _all[lineKey] ?? Progress(lineKey: lineKey);

  @override
  Future<void> save(Progress progress) async =>
      _changes.add(_all[progress.lineKey] = progress);

  @override
  Stream<Progress> watch(String lineKey) async* {
    yield await load(lineKey);
    yield* _changes.stream.where((p) => p.lineKey == lineKey);
  }
}
