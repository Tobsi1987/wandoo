import 'dart:math';

import 'package:wandoo/features/treasure/treasure.dart';
import 'package:wandoo/flows/process_walk/walk_extra.dart';

/// Legt die Fundstücke eines Gangs in die Schatzkiste.
class TreasureExtra implements WalkExtra {
  TreasureExtra(this._chests, {this.drop = const DropFinds(), Random? random})
    : _random = random ?? Random();

  final TreasureRepository _chests;
  final DropFinds drop;
  final Random _random;

  @override
  Future<List<String>> onWalk(WalkOutcome outcome) async {
    final found = drop(outcome.newSegmentsByEnvironment, _random);
    if (found.isEmpty) return const [];
    final chest = await _chests.load();
    await _chests.save(chest.add(found));
    return foundLines(found);
  }
}
