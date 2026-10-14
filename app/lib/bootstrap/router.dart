import 'package:go_router/go_router.dart';
import 'package:wandoo/bootstrap/page_extras.dart';
import 'package:wandoo/features/achievements/achievements.dart';
import 'package:wandoo/features/adventures/adventures.dart';
import 'package:wandoo/features/bath/bath.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/den/den.dart';
import 'package:wandoo/features/diary/diary.dart';
import 'package:wandoo/features/discovery_map/discovery_map.dart';
import 'package:wandoo/features/districts/districts.dart';
import 'package:wandoo/features/home/home.dart';
import 'package:wandoo/features/privacy/privacy.dart';
import 'package:wandoo/features/share/share.dart';
import 'package:wandoo/features/star_catch/star_catch.dart';
import 'package:wandoo/features/treasure/treasure.dart';

/// Alle Routen der App. Neue Screens werden nur hier eingehängt.
final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: HomeScreen.path,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: DiscoveryMapScreen.path,
      builder: (context, state) => const DiscoveryMapScreen(),
    ),
    GoRoute(
      path: ShareScreen.path,
      builder: (context, state) => const ShareScreen(),
    ),
    GoRoute(
      path: TreasureScreen.path,
      builder: (context, state) => const TreasureScreen(),
    ),
    GoRoute(
      path: AlbumScreen.path,
      builder: (context, state) =>
          AlbumScreen(actions: [achievementBookAction(), privacyAction()]),
    ),
    GoRoute(
      path: AdventureScreen.path,
      builder: (context, state) => const AdventureScreen(),
    ),
    GoRoute(
      path: PuzzleScreen.path,
      builder: (context, state) => const PuzzleScreen(),
    ),
    GoRoute(
      path: DiaryScreen.path,
      builder: (context, state) => const DiaryScreen(footer: DiaryFooter()),
    ),
    GoRoute(
      path: DenScreen.path,
      builder: (context, state) => const DenScreen(),
    ),
    GoRoute(
      path: BathScreen.path,
      builder: (context, state) => const BathScreen(),
    ),
    GoRoute(
      path: AchievementBookScreen.path,
      builder: (context, state) => const AchievementBookScreen(),
    ),
    GoRoute(
      path: PrivacyScreen.path,
      builder: (context, state) => const PrivacyScreen(),
    ),
    GoRoute(
      path: StarCatchScreen.path,
      builder: (context, state) => const StarCatchScreen(),
    ),
  ],
);
