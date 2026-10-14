import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/creature/application/creature_providers.dart';
import 'package:wandoo/features/creature/domain/species_catalog.dart';
import 'package:wandoo/features/creature/presentation/widgets/album_tile.dart';

/// Sammelalbum: alle Arten, entdeckte in Farbe, die anderen als Umriss.
class AlbumScreen extends ConsumerWidget {
  const AlbumScreen({this.actions = const [], super.key});

  static const path = '/album';

  /// Knöpfe oben rechts, vom Router eingehängt (etwa das Erfolge-Buch).
  final List<Widget> actions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seen = ref.watch(creatureProvider).value?.discoveredSpecies ?? {};
    const all = SpeciesCatalog.all;
    final found = all.where((s) => seen.contains(s.id)).length;
    return Scaffold(
      appBar: AppBar(title: const Text('Sammelalbum'), actions: actions),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '$found von ${all.length} Tieren entdeckt',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Expanded(
            child: GridView.extent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 0.8,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                for (final s in all)
                  AlbumTile(species: s, seen: seen.contains(s.id)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
