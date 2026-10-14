import 'dart:async';

import 'package:wandoo/features/creature/domain/den_repository.dart';

/// Für Tests und die Demo.
class InMemoryDenRepository implements DenRepository {
  InMemoryDenRepository([this._sleeper]);

  Sleeper? _sleeper;
  final _changes = StreamController<Sleeper?>.broadcast();

  @override
  Future<Sleeper?> load() async => _sleeper;

  @override
  Future<void> save(Sleeper sleeper) async => _changes.add(_sleeper = sleeper);

  @override
  Stream<Sleeper?> watch() async* {
    yield _sleeper;
    yield* _changes.stream;
  }
}
