import 'package:flutter/material.dart';

/// "noch 23 % unbekannt" als Plakette über der Karte.
class UnknownShareBadge extends StatelessWidget {
  const UnknownShareBadge({required this.percent, super.key});

  final int percent;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Text(
          percent == 0 ? 'Alles entdeckt!' : 'noch $percent % unbekannt',
          style: TextStyle(color: colors.onPrimaryContainer),
        ),
      ),
    );
  }
}
