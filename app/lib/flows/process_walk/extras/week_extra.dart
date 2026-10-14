import 'package:wandoo/features/friends/friends.dart';
import 'package:wandoo/flows/process_walk/walk_extra.dart';

/// Zählt jeden Gang in die Woche für die Bestenliste.
class WeekExtra implements WalkExtra {
  WeekExtra(this.friends);

  final FriendsRepository friends;

  @override
  Future<List<String>> onWalk(WalkOutcome outcome) async {
    final week = await friends.loadWeek();
    await friends.saveWeek(
      week.add(
        meters: outcome.summary.distanceMeters,
        streets: outcome.newSegmentsByEnvironment.values.fold(
          0,
          (a, b) => a + b,
        ),
        now: outcome.summary.finishedAt,
      ),
    );
    return const [];
  }
}
