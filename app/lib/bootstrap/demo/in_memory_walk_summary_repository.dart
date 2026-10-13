import 'dart:async';

import 'package:wandoo/features/walk_summary/walk_summary.dart';

/// Zusammenfassungen nur im Speicher, für die Demo.
class InMemoryWalkSummaryRepository implements WalkSummaryRepository {
  WalkSummary? _latestUnseen;
  final _changes = StreamController<WalkSummary?>.broadcast();

  @override
  Future<void> save(WalkSummary summary) async {
    _latestUnseen = summary;
    _changes.add(summary);
  }

  @override
  Stream<WalkSummary?> watchLatestUnseen() async* {
    yield _latestUnseen;
    yield* _changes.stream;
  }

  @override
  Future<void> markSeen(String walkId) async {
    if (_latestUnseen?.walkId != walkId) return;
    _latestUnseen = null;
    _changes.add(null);
  }
}
