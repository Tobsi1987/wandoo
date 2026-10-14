import 'package:wandoo/features/achievements/domain/lifetime_stats.dart';

/// Speichert die Zahlen fürs Erfolge-Buch, über alle Wesen hinweg.
abstract interface class StatsRepository {
  Future<LifetimeStats> load();

  Future<void> save(LifetimeStats stats);

  Stream<LifetimeStats> watch();
}
