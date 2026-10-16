import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/den/application/room_providers.dart';
import 'package:wandoo/features/den/domain/den_room.dart';
import 'package:wandoo/features/den/domain/furniture.dart';
import 'package:wandoo/features/den/presentation/furniture_labels.dart';
import 'package:wandoo/features/den/presentation/widgets/furniture_piece.dart';
import 'package:wandoo/features/treasure/treasure.dart';
import 'package:wandoo/ui_kit/word_safe_text.dart';

/// Auswahl für einen Platz: drei Möbel, bauen oder hinstellen.
Future<void> showFurnitureSheet(BuildContext context, Spot spot) =>
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => _FurnitureSheet(spot: spot),
    );

class _FurnitureSheet extends ConsumerWidget {
  const _FurnitureSheet({required this.spot});

  final Spot spot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final room = ref.watch(roomProvider).value ?? const DenRoom();
    final chest =
        ref.watch(treasureChestProvider).value ?? const TreasureChest();
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              spotName(spot),
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            for (final f in Furniture.at(spot))
              _row(context, ref, f, room, chest),
            if (room.at(spot) != null)
              TextButton(
                onPressed: () => unawaited(_save(ref, (r) => r.clear(spot))),
                child: const Text('Platz leer räumen'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _row(
    BuildContext context,
    WidgetRef ref,
    Furniture f,
    DenRoom room,
    TreasureChest chest,
  ) {
    final owned = room.owned.contains(f);
    final placed = room.at(spot) == f;
    final needs = [
      for (final e in f.recipe.entries)
        '${findEmoji(e.key)} ${chest.count(e.key)}/${e.value}',
    ].join(' · ');
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Row(
          children: [
            FurniturePiece(furniture: f, size: 52),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WordSafeText(
                    furnitureName(f),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    perkLabel(f),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    owned ? (placed ? 'Steht im Zuhause' : 'Im Lager') : needs,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _action(ref, f, owned: owned, placed: placed, chest: chest),
          ],
        ),
      ),
    );
  }

  Widget _action(
    WidgetRef ref,
    Furniture f, {
    required bool owned,
    required bool placed,
    required TreasureChest chest,
  }) {
    if (placed) {
      return const Icon(Icons.check_circle_rounded, color: Colors.green);
    }
    const compact = VisualDensity.compact;
    if (owned) {
      return OutlinedButton(
        style: OutlinedButton.styleFrom(visualDensity: compact),
        onPressed: () => unawaited(_save(ref, (r) => r.put(f))),
        child: const Text('Hinstellen'),
      );
    }
    return FilledButton(
      style: FilledButton.styleFrom(visualDensity: compact),
      onPressed: chest.canAfford(f.recipe)
          ? () => unawaited(ref.read(buildFurnitureProvider)(f))
          : null,
      child: const Text('Bauen'),
    );
  }

  static Future<void> _save(
    WidgetRef ref,
    DenRoom Function(DenRoom) change,
  ) async {
    final repo = ref.read(roomRepositoryProvider);
    await repo.save(change(await repo.load()));
  }
}
