import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/adventures/domain/adventure_repository.dart';
import 'package:wandoo/features/adventures/domain/plan_week.dart';
import 'package:wandoo/features/adventures/domain/weekly_adventure.dart';

/// Wird im Bootstrap überschrieben.
final adventureRepositoryProvider = Provider<AdventureRepository>(
  (ref) => throw UnimplementedError('adventureRepositoryProvider'),
);

/// Uhr für die Wochengrenze; in Tests überschreibbar.
final adventureClockProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);

/// Die Abenteuer dieser Woche. Ist die gespeicherte Woche vorbei oder gibt
/// es noch keine, die frisch geplante.
final weeklyAdventureProvider = StreamProvider<WeeklyAdventure>((ref) {
  final now = ref.watch(adventureClockProvider);
  return ref.watch(adventureRepositoryProvider).watch().map((stored) {
    final today = now();
    return stored != null && stored.isWeekOf(today)
        ? stored
        : const PlanWeek()(today);
  });
});
