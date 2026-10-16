import 'package:flutter/material.dart';
import 'package:wandoo/features/districts/domain/district_name.dart';
import 'package:wandoo/features/districts/domain/district_progress.dart';

/// Ein Teil des Viertel-Puzzles: gelegt (Abzeichen), Wildnis oder offen.
class PuzzlePiece extends StatelessWidget {
  const PuzzlePiece({
    required this.state,
    required this.here,
    this.onTap,
    super.key,
  });

  final DistrictState state;

  /// Hier steht man gerade.
  final bool here;

  /// Antippen zeigt, was zum Viertel gehört.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final name = districtName(state.district);
    final (color, icon, line) = state.wild
        ? (const Color(0xFFDDEBD3), '🌲', 'Wildnis')
        : state.badge
        ? (scheme.primaryContainer, '🏅', 'Geschafft')
        : (scheme.surfaceContainerHighest, '🧩', '${state.percent} %');
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: here
          ? BorderSide(color: scheme.primary, width: 3)
          : BorderSide.none,
    );
    return Semantics(
      label: state.wild ? 'Wildnis' : '$name, $line',
      button: onTap != null,
      excludeSemantics: true,
      child: Material(
        color: color,
        shape: shape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: FittedBox(
              child: Column(
                children: [
                  Text(
                    here ? '📍' : icon,
                    style: const TextStyle(fontSize: 22),
                  ),
                  if (!state.wild)
                    Text(name, style: const TextStyle(fontSize: 11)),
                  Text(line, style: const TextStyle(fontSize: 11)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
