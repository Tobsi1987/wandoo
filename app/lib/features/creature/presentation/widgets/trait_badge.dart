import 'package:flutter/material.dart';
import 'package:wandoo/features/creature/domain/trait.dart';

/// Zeigt ein Merkmal und wie stark es ausgeprägt ist.
class TraitBadge extends StatelessWidget {
  const TraitBadge({required this.trait, required this.points, super.key});

  final Trait trait;
  final int points;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text('${_label(trait)} $points'));
  }

  static String _label(Trait trait) => switch (trait) {
    Trait.moss => 'Moos',
    Trait.fins => 'Flossen',
    Trait.lanterns => 'Laternen',
    Trait.wheatEars => 'Ähren',
  };
}
