import 'dart:async';

import 'package:wandoo/features/bath/domain/mud_repository.dart';

/// Hält den Matsch nur im Speicher, für Demo und Tests.
class InMemoryMudRepository implements MudRepository {
  InMemoryMudRepository([Map<String, int> start = const {}])
    : _all = {...start};

  final Map<String, int> _all;
  final _changes = StreamController<(String, int)>.broadcast();

  @override
  Future<int> load(String lineKey) async => _all[lineKey] ?? 0;

  @override
  Future<void> save(String lineKey, int level) async =>
      _changes.add((lineKey, _all[lineKey] = level));

  @override
  Stream<int> watch(String lineKey) async* {
    yield _all[lineKey] ?? 0;
    yield* _changes.stream.where((c) => c.$1 == lineKey).map((c) => c.$2);
  }
}
