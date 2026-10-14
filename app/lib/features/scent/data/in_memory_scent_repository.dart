import 'dart:async';

import 'package:wandoo/features/scent/domain/scent.dart';
import 'package:wandoo/features/scent/domain/scent_repository.dart';

/// Hält die Spur nur im Speicher, für Demo und Tests.
class InMemoryScentRepository implements ScentRepository {
  Scent? _scent;
  final _changes = StreamController<Scent?>.broadcast();

  /// Die Spur sofort, ohne zu warten (für die simulierten Gänge der Demo).
  Scent? get current => _scent;

  @override
  Future<Scent?> load() async => _scent;

  @override
  Future<void> save(Scent scent) async => _changes.add(_scent = scent);

  @override
  Future<void> clear() async => _changes.add(_scent = null);

  @override
  Stream<Scent?> watch() async* {
    yield _scent;
    yield* _changes.stream;
  }
}
