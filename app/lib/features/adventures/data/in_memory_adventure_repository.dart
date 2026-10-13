import 'dart:async';

import 'package:wandoo/features/adventures/domain/adventure_repository.dart';
import 'package:wandoo/features/adventures/domain/weekly_adventure.dart';

/// Abenteuer nur im Speicher, für Tests und die Demo.
class InMemoryAdventureRepository implements AdventureRepository {
  WeeklyAdventure? _adventure;
  final _changes = StreamController<WeeklyAdventure?>.broadcast();

  @override
  Future<WeeklyAdventure?> load() async => _adventure;

  @override
  Future<void> save(WeeklyAdventure adventure) async {
    _adventure = adventure;
    _changes.add(adventure);
  }

  @override
  Stream<WeeklyAdventure?> watch() async* {
    yield _adventure;
    yield* _changes.stream;
  }
}
