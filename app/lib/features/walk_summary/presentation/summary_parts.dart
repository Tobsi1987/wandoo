import 'package:flutter/material.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/core/format/distance_label.dart';
import 'package:wandoo/features/walk_summary/domain/walk_summary.dart';

/// Zwei große Zahlen nebeneinander: neue Straßen und gelaufene Strecke.
class SummaryStats extends StatelessWidget {
  const SummaryStats({required this.summary, super.key});

  final WalkSummary summary;

  @override
  Widget build(BuildContext context) {
    final n = summary.newStreetCount;
    final meters = summary.distanceMeters;
    final stats = [
      if (!summary.foundNothing)
        _Stat(value: '+$n', label: n == 1 ? 'neue Straße' : 'neue Straßen'),
      if (meters > 0) _Stat(value: distanceLabel(meters), label: 'gelaufen'),
    ];
    if (stats.isEmpty) return const SizedBox.shrink();
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < stats.length; i++) ...[
            if (i > 0)
              const VerticalDivider(width: 32, indent: 8, endIndent: 8),
            stats[i],
          ],
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          value,
          style: text.displaySmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(label, style: text.labelLarge),
      ],
    );
  }
}

/// Ein Schild für etwas Mitgebrachtes, z. B. "🌺 2 Mohnblumen".
class NewsPill extends StatelessWidget {
  const NewsPill({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Text(text, style: TextStyle(color: colors.onSecondaryContainer)),
      ),
    );
  }
}

/// "🌲 5 Wald · 🏙️ 4 Stadt · 🌉 1 Brücke"
String placesLine(WalkSummary summary) => [
  for (final type in _order)
    if ((summary.streetsByEnvironment[type] ?? 0) > 0)
      '${_emoji(type)} ${summary.streetsByEnvironment[type]} ${_word(type)}',
  if (summary.bridgeCount > 0)
    '🌉 ${summary.bridgeCount} ${_bridges(summary.bridgeCount)}',
].join('  ·  ');

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

String _emoji(EnvironmentType type) => switch (type) {
  EnvironmentType.forest => '🌲',
  EnvironmentType.water => '💧',
  EnvironmentType.field => '🌾',
  EnvironmentType.city => '🏙️',
  EnvironmentType.unknown => '🛤️',
};

String _bridges(int n) => n == 1 ? 'Brücke' : 'Brücken';
