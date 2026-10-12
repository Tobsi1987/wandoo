import 'package:go_router/go_router.dart';
import 'package:wandoo/features/creature/creature.dart';

/// Alle Routen der App. Neue Screens werden nur hier eingehängt.
final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: CreatureScreen.path,
      builder: (context, state) => const CreatureScreen(),
    ),
  ],
);
