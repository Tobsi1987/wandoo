import 'dart:async';

import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/tracking/tracking.dart';

/// Offene Gänge nur im Speicher, für die Demo.
class InMemoryRecordedWalkRepository implements RecordedWalkRepository {
  final List<Track> _pending = [];
  final _changes = StreamController<int>.broadcast();

  @override
  Future<void> saveFinished(Track track) async {
    _pending.add(track);
    _changes.add(_pending.length);
  }

  @override
  Future<void> saveProgress(Track track) async {}

  @override
  Future<Track?> unfinished() async => null;

  @override
  Future<void> discard(String trackId) async {}

  @override
  Future<List<Track>> pending() async => List.of(_pending);

  @override
  Stream<int> watchPendingCount() async* {
    yield _pending.length;
    yield* _changes.stream;
  }

  @override
  Future<void> markProcessed(String trackId) async {
    _pending.removeWhere((t) => t.id == trackId);
    _changes.add(_pending.length);
  }
}
