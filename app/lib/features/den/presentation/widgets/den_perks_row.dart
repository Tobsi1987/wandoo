import 'package:flutter/material.dart';
import 'package:wandoo/features/den/domain/den_room.dart';
import 'package:wandoo/features/den/domain/furniture_perk.dart';

/// Was die aufgestellten Möbel gerade bringen, als zwei kleine Plaketten.
class DenPerksRow extends StatelessWidget {
  const DenPerksRow({required this.room, super.key});

  final DenRoom room;

  @override
  Widget build(BuildContext context) {
    final xp = room.percent(Perk.xp);
    final hunger = room.percent(Perk.hunger);
    if (xp == 0 && hunger == 0) {
      return Text(
        'Tippe auf einen Platz und baue Möbel aus deinen Fundstücken. '
        'Jedes Möbelstück bringt einen Bonus.',
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      );
    }
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 6,
      children: [
        if (xp > 0) _Badge('⭐ +$xp % Erfahrung'),
        if (hunger > 0) _Badge('🍎 $hunger % weniger Hunger'),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          text,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: scheme.onPrimaryContainer,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
