import 'package:wandoo/core/memory/memory_value.dart';
import 'package:wandoo/features/achievements/domain/lifetime_stats.dart';
import 'package:wandoo/features/achievements/domain/stats_repository.dart';

/// Für Tests und die Demo.
class InMemoryStatsRepository extends MemoryValue<LifetimeStats>
    implements StatsRepository {
  InMemoryStatsRepository([super.value = const LifetimeStats()]);
}
