import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/creature/application/release_creature_action.dart';
import 'package:wandoo/features/creature/domain/creature.dart';
import 'package:wandoo/features/creature/domain/species_catalog.dart';
import 'package:wandoo/features/creature/presentation/creature_labels.dart';

/// "Wegschicken": Das Wesen zieht in die Wildnis, ein neues Ei kommt.
/// Während der Pause ist der Knopf grau und sagt, wie lange noch.
class ReleaseButton extends ConsumerWidget {
  const ReleaseButton({required this.creature, super.key});

  final Creature creature;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!creature.hatched) return const SizedBox.shrink();
    final action = ref.watch(releaseCreatureProvider);
    final left = action.rule.waitLeft(creature, DateTime.now());
    if (left > Duration.zero) {
      return TextButton.icon(
        onPressed: null,
        icon: const Icon(Icons.hourglass_bottom),
        label: Text('Wegschicken ${waitLabel(left)}'),
      );
    }
    return TextButton.icon(
      onPressed: () => unawaited(_confirm(context, action)),
      icon: const Icon(Icons.waving_hand_outlined),
      label: const Text('Wegschicken'),
    );
  }

  Future<void> _confirm(
    BuildContext context,
    ReleaseCreatureAction action,
  ) async {
    final name = SpeciesCatalog.byId(creature.speciesId).name;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$name wegschicken?'),
        content: Text(
          '$name zieht in die Wildnis und kommt nicht zurück. Danach '
          'wartet ein neues Ei auf dich. Wegschicken geht nur alle '
          '${action.rule.cooldown.inDays} Tage.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Behalten'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Wegschicken'),
          ),
        ],
      ),
    );
    if (ok ?? false) await action(DateTime.now());
  }
}
