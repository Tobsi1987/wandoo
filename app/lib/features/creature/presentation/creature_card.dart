import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/creature/application/creature_providers.dart';
import 'package:wandoo/features/creature/presentation/widgets/creature_avatar.dart';
import 'package:wandoo/features/creature/presentation/widgets/release_button.dart';

/// Zeigt das aktuelle Wesen. Wird auf dem Startbildschirm eingebettet.
class CreatureCard extends ConsumerWidget {
  const CreatureCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(creatureProvider)
        .when(
          data: (c) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CreatureAvatar(creature: c),
              ReleaseButton(creature: c),
            ],
          ),
          loading: () => const CircularProgressIndicator(),
          error: (error, _) => Text('Fehler: $error'),
        );
  }
}
