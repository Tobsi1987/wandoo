import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/creature/application/creature_providers.dart';
import 'package:wandoo/features/creature/domain/creature.dart';
import 'package:wandoo/features/creature/presentation/widgets/creature_avatar.dart';
import 'package:wandoo/features/creature/presentation/widgets/release_button.dart';
import 'package:wandoo/features/world/world.dart';

/// Zeigt das aktuelle Wesen. Wird auf dem Startbildschirm eingebettet,
/// der die Welt dahinter selbst zeichnet.
class CreatureCard extends ConsumerWidget {
  const CreatureCard({
    this.walking = false,
    this.figureSize = 220,
    this.details = true,
    this.figureWrap,
    this.below = const [],
    this.actions = const [],
    this.release = true,
    this.fill = false,
    super.key,
  });

  /// Während eines Gangs ist das Wesen wach und freut sich.
  final bool walking;
  final double figureSize;

  /// Merkmale, Weltsatz und "Wegschicken" zeigen.
  final bool details;

  /// Legt etwas um die Figur, zum Beispiel Streicheln.
  final Widget Function(Widget figure)? figureWrap;

  /// Steht immer unter Name und Stufe, zum Beispiel Herzen.
  final List<Widget> below;

  /// Knöpfe neben "Wegschicken", nur mit [details] und nicht unterwegs.
  final List<Widget> actions;

  /// Den Knopf "Wegschicken" unter dem Wesen zeigen.
  final bool release;

  /// Füllt die Höhe, die Figur passt sich an (siehe [CreatureAvatar]).
  final bool fill;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final world = ref.watch(worldStateProvider);
    return ref
        .watch(creatureProvider)
        .when(
          data: (c) => _content(c, world),
          loading: () => const CircularProgressIndicator(),
          error: (error, _) => Text('Fehler: $error'),
        );
  }

  Widget _content(Creature c, WorldState world) {
    final line = !walking
        ? worldLine(world)
        : c.hatched
        ? 'Juhu, ein Ausflug! Dein Wesen läuft mit.'
        : 'Dein Ei kommt mit auf den Ausflug.';
    return CreatureAvatar(
      creature: c,
      world: world,
      figureSize: figureSize,
      inScene: true,
      walking: walking,
      fill: fill,
      figureWrap: figureWrap,
      footer: [
        ...below,
        if (details && line != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(line, textAlign: TextAlign.center),
          ),
        if (details && !walking && (release || actions.isNotEmpty))
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              ...actions,
              if (release) ReleaseButton(creature: c),
            ],
          ),
      ],
    );
  }
}
