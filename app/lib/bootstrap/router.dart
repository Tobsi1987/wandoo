import 'package:go_router/go_router.dart';
import 'package:wandoo/features/discovery_map/discovery_map.dart';
import 'package:wandoo/features/home/home.dart';

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
  ],
);
