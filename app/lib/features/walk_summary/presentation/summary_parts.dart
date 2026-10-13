import 'package:flutter/material.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/walk_summary/domain/walk_summary.dart';

/// Groß oben: "+9 neue Straßen".
class NewStreetsHeader extends StatelessWidget {
  const NewStreetsHeader({required this.summary, super.key});

  final WalkSummary summary;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final n = summary.newStreetCount;
    return Column(
      children: [
        Text('Toller Gang!', style: text.titleMedium),
        Text(
          '+$n',
          style: text.displayMedium?.copyWith(
            color: colors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(n == 1 ? 'neue Straße' : 'neue Straßen', style: text.titleSmall),
      ],
    );
  }
}

/// Oben, wenn nur bekannte Wege dabei waren.
class KnownWaysHeader extends StatelessWidget {
  const KnownWaysHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      children: [
        Text('Dein Wesen ist satt', style: text.titleLarge),
        const SizedBox(height: 4),
        Text(
          'Wachsen tut es nur auf neuen Straßen. '
          'Probier mal eine andere Abzweigung!',
          style: text.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Eine Zeile mit etwas Besonderem, z. B. einem Fund.
class HighlightRow extends StatelessWidget {
  const HighlightRow({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        Icon(
          Icons.star_rounded,
          size: 20,
          color: Theme.of(context).colorScheme.tertiary,
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    ),
  );
}

/// Kleine Schilder je Umgebung: "5 Wald", "4 Stadt", "1 Brücke".
List<Widget> placeChips(WalkSummary summary) => [
  for (final type in _order)
    if ((summary.streetsByEnvironment[type] ?? 0) > 0)
      _PlaceChip(
        icon: _icon(type),
        label: '${summary.streetsByEnvironment[type]} ${_word(type)}',
      ),
  if (summary.bridgeCount > 0)
    _PlaceChip(
      icon: Icons.architecture,
      label:
          '${summary.bridgeCount} '
          '${summary.bridgeCount == 1 ? 'Brücke' : 'Brücken'}',
    ),
];

const List<EnvironmentType> _order = [
  EnvironmentType.forest,
  EnvironmentType.water,
  EnvironmentType.field,
  EnvironmentType.city,
];

String _word(EnvironmentType type) => switch (type) {
  EnvironmentType.forest => 'Wald',
  EnvironmentType.water => 'Wasser',
  EnvironmentType.field => 'Feld',
  EnvironmentType.city => 'Stadt',
  EnvironmentType.unknown => 'Weg',
};

IconData _icon(EnvironmentType type) => switch (type) {
  EnvironmentType.forest => Icons.park,
  EnvironmentType.water => Icons.water,
  EnvironmentType.field => Icons.grass,
  EnvironmentType.city => Icons.location_city,
  EnvironmentType.unknown => Icons.route,
};

class _PlaceChip extends StatelessWidget {
  const _PlaceChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: colors.onSecondaryContainer),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(color: colors.onSecondaryContainer)),
          ],
        ),
      ),
    );
  }
}
