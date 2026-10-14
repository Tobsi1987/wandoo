import 'dart:async';

import 'package:wandoo/features/achievements/domain/lifetime_stats.dart';
import 'package:wandoo/features/achievements/domain/stats_repository.dart';

/// Für Tests und die Demo.
class InMemoryStatsRepository implements StatsRepository {
  InMemoryStatsRepository([this._stats = const LifetimeStats()]);

  LifetimeStats _stats;
  final _changes = StreamController<LifetimeStats>.broadcast();

  @override
  Future<LifetimeStats> load() async => _stats;

  @override
  Future<void> save(LifetimeStats stats) async => _changes.add(_stats = stats);

  @override
  Stream<LifetimeStats> watch() async* {
    yield _stats;
    yield* _changes.stream;
  }
}
