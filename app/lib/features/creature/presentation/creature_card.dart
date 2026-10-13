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
    super.key,
  });

  /// Während eines Gangs ist das Wesen wach und freut sich.
  final bool walking;
  final double figureSize;

  /// Merkmale, Weltsatz und "Wegschicken" zeigen.
  final bool details;

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
      footer: [
        if (details && line != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(line, textAlign: TextAlign.center),
          ),
        if (details && !walking) ReleaseButton(creature: c),
      ],
    );
  }
}
