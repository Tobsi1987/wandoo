import 'dart:async';

import 'package:wandoo/features/hunger/domain/belly.dart';
import 'package:wandoo/features/hunger/domain/belly_repository.dart';
import 'package:wandoo/features/hunger/domain/farewell.dart';

/// Für Tests und die Demo.
class InMemoryBellyRepository implements BellyRepository {
  InMemoryBellyRepository([Iterable<Belly> start = const []])
    : _all = {for (final b in start) b.lineKey: b};

  final Map<String, Belly> _all;
  Farewell? _letter;
  final _bellies = StreamController<Belly>.broadcast();
  final _letters = StreamController<Farewell?>.broadcast();

  Farewell? get letter => _letter;

  @override
  Future<Belly?> load(String lineKey) async => _all[lineKey];

  @override
  Future<void> save(Belly belly) async =>
      _bellies.add(_all[belly.lineKey] = belly);

  @override
  Stream<Belly?> watch(String lineKey) async* {
    yield _all[lineKey];
    yield* _bellies.stream.where((b) => b.lineKey == lineKey);
  }

  @override
  Future<void> leaveLetter(Farewell? farewell) async =>
      _letters.add(_letter = farewell);

  @override
  Stream<Farewell?> watchLetter() async* {
    yield _letter;
    yield* _letters.stream;
  }
}
