import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/treasure/application/treasure_providers.dart';
import 'package:wandoo/features/treasure/domain/accessory.dart';
import 'package:wandoo/features/treasure/domain/treasure_chest.dart';
import 'package:wandoo/features/treasure/presentation/treasure_labels.dart';

/// Ein Deko-Teil: basteln, sobald genug gesammelt ist, dann an- und
/// ausziehen.
class AccessoryTile extends ConsumerWidget {
  const AccessoryTile({
    required this.accessory,
    required this.chest,
    required this.creature,
    super.key,
  });

  final Accessory accessory;
  final TreasureChest chest;
  final Creature creature;

  bool get _worn =>
      (hatFor(accessory) != null && creature.hat == hatFor(accessory)) ||
      (neckFor(accessory) != null && creature.neck == neckFor(accessory));

  String get _ownedLabel => _worn ? 'Trägt dein Wesen' : 'Gebastelt';

  /// "🌰 2/6 · 🌺 3/3", oder dass der Bauplan noch fehlt.
  String get _needs => chest.knows(accessory)
      ? [
          for (final e in accessory.recipe.entries)
            '${findEmoji(e.key)} ${chest.count(e.key)}/${e.value}',
        ].join(' · ')
      : '📜 Bauplan fehlt, kommt mit einem Level-Aufstieg';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.read(treasureActionsProvider);
    final owned = chest.owned.contains(accessory);
    return Card(
      child: ListTile(
        title: Text(accessoryName(accessory)),
        subtitle: Text(owned ? _ownedLabel : _needs),
        trailing: owned
            ? (creature.hatched
                  ? OutlinedButton(
                      onPressed: () => unawaited(actions.toggleWear(accessory)),
                      child: Text(_worn ? 'Ausziehen' : 'Anziehen'),
                    )
                  : null)
            : FilledButton(
                onPressed: chest.canCraft(accessory)
                    ? () => unawaited(actions.craft(accessory))
                    : null,
                child: const Text('Basteln'),
              ),
      ),
    );
  }
}
