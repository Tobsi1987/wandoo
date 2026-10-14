import 'dart:async';

import 'package:wandoo/features/hunger/domain/belly.dart';
import 'package:wandoo/features/hunger/domain/belly_repository.dart';
import 'package:wandoo/features/hunger/domain/farewell.dart';

/// Für Tests und die Demo.
class InMemoryBellyRepository implements BellyRepository {
  InMemoryBellyRepository([this._belly]);

  Belly? _belly;
  Farewell? _letter;
  final _bellies = StreamController<Belly?>.broadcast();
  final _letters = StreamController<Farewell?>.broadcast();

  Farewell? get letter => _letter;

  @override
  Future<Belly?> load() async => _belly;

  @override
  Future<void> save(Belly belly) async => _bellies.add(_belly = belly);

  @override
  Stream<Belly?> watch() async* {
    yield _belly;
    yield* _bellies.stream;
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
