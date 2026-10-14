import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/treasure/application/treasure_providers.dart';
import 'package:wandoo/features/treasure/domain/accessory.dart';
import 'package:wandoo/features/treasure/domain/find.dart';
import 'package:wandoo/features/treasure/presentation/treasure_labels.dart';
import 'package:wandoo/features/treasure/presentation/widgets/accessory_tile.dart';

/// Schatzkiste: gesammelte Fundstücke und Deko zum Basteln und Anziehen,
/// sortiert von einfach bis selten.
class TreasureScreen extends ConsumerWidget {
  const TreasureScreen({super.key});

  static const path = '/schatzkiste';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chest = ref.watch(treasureChestProvider).value;
    final creature = ref.watch(creatureProvider).value;
    return Scaffold(
      appBar: AppBar(title: const Text('Schatzkiste')),
      body: chest == null || creature == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(child: CreatureFigure(creature: creature, size: 160)),
                const WorldMarksSwitch(),
                const SizedBox(height: 16),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final f in Find.values)
                      Chip(
                        label: Text(
                          '${findEmoji(f)} ${chest.count(f)} '
                          '${findNames(f).$2}',
                        ),
                      ),
                  ],
                ),
                for (final tier in CraftTier.values) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 20, 4, 6),
                    child: Text(
                      craftTierName(tier),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  for (final a in Accessory.values)
                    if (a.tier == tier)
                      AccessoryTile(
                        accessory: a,
                        chest: chest,
                        creature: creature,
                      ),
                ],
              ],
            ),
    );
  }
}
