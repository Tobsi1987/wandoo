import 'package:flutter/material.dart';
import 'package:wandoo/features/creature/domain/trait.dart';
import 'package:wandoo/features/creature/presentation/creature_labels.dart';

/// Zeigt ein Merkmal und wie stark es ausgeprägt ist.
class TraitBadge extends StatelessWidget {
  const TraitBadge({required this.trait, required this.points, super.key});

  final Trait trait;
  final int points;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Text(
          '${traitLabel(trait)} $points',
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    );
  }
}
