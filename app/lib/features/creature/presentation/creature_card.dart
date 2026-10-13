import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/creature/application/creature_providers.dart';
import 'package:wandoo/features/creature/presentation/widgets/creature_avatar.dart';
import 'package:wandoo/features/creature/presentation/widgets/release_button.dart';
import 'package:wandoo/features/world/world.dart';

/// Zeigt das aktuelle Wesen. Wird auf dem Startbildschirm eingebettet.
class CreatureCard extends ConsumerWidget {
  const CreatureCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final world = ref.watch(worldStateProvider);
    final line = worldLine(world);
    return ref
        .watch(creatureProvider)
        .when(
          data: (c) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CreatureAvatar(creature: c, world: world),
              if (line != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(line, textAlign: TextAlign.center),
                ),
              ReleaseButton(creature: c),
            ],
          ),
          loading: () => const CircularProgressIndicator(),
          error: (error, _) => Text('Fehler: $error'),
        );
  }
}
