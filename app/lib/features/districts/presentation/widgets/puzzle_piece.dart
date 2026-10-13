import 'package:flutter/material.dart';
import 'package:wandoo/features/districts/domain/district_name.dart';
import 'package:wandoo/features/districts/domain/district_progress.dart';

/// Ein Teil des Viertel-Puzzles: gelegt (Abzeichen), Wildnis oder offen.
class PuzzlePiece extends StatelessWidget {
  const PuzzlePiece({required this.state, required this.here, super.key});

  final DistrictState state;

  /// Hier steht man gerade.
  final bool here;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final name = districtName(state.district);
    final (color, icon, line) = state.wild
        ? (const Color(0xFFDDEBD3), '🌲', 'Wildnis')
        : state.badge
        ? (scheme.primaryContainer, '🏅', 'Geschafft')
        : (scheme.surfaceContainerHighest, '🧩', '${state.percent} %');
    return Semantics(
      label: state.wild ? 'Wildnis' : '$name, $line',
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: here ? Border.all(color: scheme.primary, width: 3) : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: FittedBox(
            child: Column(
              children: [
                Text(here ? '📍' : icon, style: const TextStyle(fontSize: 22)),
                if (!state.wild)
                  Text(name, style: const TextStyle(fontSize: 11)),
                Text(line, style: const TextStyle(fontSize: 11)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
