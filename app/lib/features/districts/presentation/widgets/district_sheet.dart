import 'package:flutter/material.dart';
import 'package:wandoo/features/districts/domain/district_name.dart';
import 'package:wandoo/features/districts/domain/district_progress.dart';
import 'package:wandoo/features/districts/domain/district_streets.dart';
import 'package:wandoo/features/districts/domain/puzzle.dart';
import 'package:wandoo/features/districts/presentation/widgets/district_sketch.dart';

/// Zeigt, was zu einem Viertel gehört: Skizze und Straßen.
Future<void> showDistrictSheet(
  BuildContext context,
  Puzzle puzzle,
  DistrictState state,
) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => DraggableScrollableSheet(
    expand: false,
    initialChildSize: 0.7,
    maxChildSize: 0.95,
    builder: (_, controller) =>
        DistrictSheet(puzzle: puzzle, state: state, controller: controller),
  ),
);

/// Inhalt des Blatts zu einem Viertel.
class DistrictSheet extends StatelessWidget {
  const DistrictSheet({
    required this.puzzle,
    required this.state,
    this.controller,
    super.key,
  });

  final Puzzle puzzle;
  final DistrictState state;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final segments = puzzle.segments[state.district] ?? const [];
    final streets = DistrictStreets(segments, puzzle.knownIds);
    return ListView(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        Text(districtName(state.district), style: text.titleLarge),
        const SizedBox(height: 4),
        Text(_summary),
        const SizedBox(height: 12),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 240),
            child: DistrictSketch(
              district: state.district,
              segments: segments,
              knownIds: puzzle.knownIds,
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (streets.named.isNotEmpty)
          Text('Straßen in diesem Viertel', style: text.titleMedium),
        for (final s in streets.named) _StreetRow(street: s),
        if (streets.unnamedMeters >= 50)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Dazu kommen ${_length(streets.unnamedMeters)} kleine Wege '
              'ohne Namen.',
            ),
          ),
      ],
    );
  }

  String get _summary {
    if (state.wild) {
      return 'Hier ist Wildnis: Wald, Wasser oder Felder. Kaum Wege, '
          'darum gibt es kein Puzzleteil.';
    }
    final line = state.badge
        ? 'Geschafft! Das Abzeichen gehört dir.'
        : 'Noch ${_badgePercent - state.percent} % bis zum Abzeichen.';
    return '${state.percent} % der Wege entdeckt '
        '(${_length(state.meters)} insgesamt). $line';
  }

  static final int _badgePercent = (DistrictState.badgeShare * 100).round();

  static String _length(double meters) => meters >= 1000
      ? '${(meters / 1000).toStringAsFixed(1).replaceAll('.', ',')} km'
      : '${meters.round()} m';
}

class _StreetRow extends StatelessWidget {
  const _StreetRow({required this.street});

  final DistrictStreet street;

  @override
  Widget build(BuildContext context) => ListTile(
    dense: true,
    contentPadding: EdgeInsets.zero,
    leading: Text(
      street.done ? '✅' : (street.percent > 0 ? '👣' : '❔'),
      style: const TextStyle(fontSize: 20),
    ),
    title: Text(street.name),
    trailing: Text('${street.percent} %'),
  );
}
