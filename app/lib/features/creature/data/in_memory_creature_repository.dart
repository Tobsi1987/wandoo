import 'dart:async';

import 'package:wandoo/features/creature/domain/creature.dart';
import 'package:wandoo/features/creature/domain/creature_repository.dart';

/// Hält das Wesen nur im Speicher. Für Tests.
class InMemoryCreatureRepository implements CreatureRepository {
  Creature _creature = const Creature();
  final _changes = StreamController<Creature>.broadcast();

  @override
  Future<Creature> load() async => _creature;

  @override
  Future<void> save(Creature creature) async {
    _creature = creature;
    _changes.add(creature);
  }

  @override
  Stream<Creature> watch() async* {
    yield _creature;
    yield* _changes.stream;
  }
}
