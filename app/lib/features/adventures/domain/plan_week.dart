import 'dart:math';

import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/adventures/domain/quest.dart';
import 'package:wandoo/features/adventures/domain/weekly_adventure.dart';

/// Stellt die drei Abenteuer einer Woche zusammen.
///
/// Dieselbe Woche ergibt immer dieselben Abenteuer, auch nach einer
/// Neuinstallation.
class PlanWeek {
  const PlanWeek();

  static const _places = <EnvironmentType>[
    EnvironmentType.forest,
    EnvironmentType.water,
    EnvironmentType.city,
    EnvironmentType.field,
  ];

  WeeklyAdventure call(DateTime now) {
    final week = WeeklyAdventure.weekOf(now);
    final random = Random(_seed(week));
    final place = _places[random.nextInt(_places.length)];
    final bonus = _places[random.nextInt(_places.length)];
    final third = random.nextBool()
        ? Quest(
            kind: QuestKind.discoveryWalks,
            goal: 3,
            rewardEnvironment: bonus,
            rewardCount: 2,
          )
        : Quest(
            kind: QuestKind.bigWalk,
            goal: 12,
            rewardEnvironment: bonus,
            rewardCount: 2,
          );
    return WeeklyAdventure(
      weekStart: week,
      quests: [
        Quest(kind: QuestKind.newSegments, goal: 25 + 5 * random.nextInt(3)),
        Quest(
          kind: QuestKind.newInEnvironment,
          environment: place,
          goal: 8,
          rewardEnvironment: place,
          rewardCount: 3,
        ),
        third,
      ],
    );
  }

  static int _seed(DateTime week) =>
      DateTime.utc(week.year, week.month, week.day).millisecondsSinceEpoch ~/
      Duration.millisecondsPerDay;
}
