import 'dart:async';

import 'package:wandoo/features/treasure/domain/treasure_chest.dart';
import 'package:wandoo/features/treasure/domain/treasure_repository.dart';

/// Schatzkiste nur im Speicher, für Tests und die Demo.
class InMemoryTreasureRepository implements TreasureRepository {
  TreasureChest _chest = const TreasureChest();
  final _changes = StreamController<TreasureChest>.broadcast();

  @override
  Future<TreasureChest> load() async => _chest;

  @override
  Future<void> save(TreasureChest chest) async {
    _chest = chest;
    _changes.add(chest);
  }

  @override
  Stream<TreasureChest> watch() async* {
    yield _chest;
    yield* _changes.stream;
  }
}
