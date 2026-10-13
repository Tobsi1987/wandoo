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
    return Chip(label: Text('${traitLabel(trait)} $points'));
  }
}
