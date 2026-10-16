import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/districts/application/district_providers.dart';
import 'package:wandoo/features/districts/domain/district_name.dart';
import 'package:wandoo/features/districts/domain/puzzle.dart';
import 'package:wandoo/features/districts/presentation/widgets/district_sheet.dart';
import 'package:wandoo/features/districts/presentation/widgets/puzzle_piece.dart';

/// Viertel-Puzzle: Jedes Viertel der Gegend ist ein Teil. Ab 80 %
/// entdeckt gibt es ein Abzeichen und das Teil liegt im Puzzle.
class PuzzleScreen extends ConsumerWidget {
  const PuzzleScreen({super.key});

  static const path = '/puzzle';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Viertel-Puzzle')),
      body: ref
          .watch(puzzleProvider)
          .when(
            data: (p) => p == null
                ? const _Message('Ohne Standort gibt es kein Puzzle.')
                : _PuzzleBody(puzzle: p),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) =>
                const _Message('Kartendaten konnten nicht geladen werden.'),
          ),
    );
  }
}

class _PuzzleBody extends StatelessWidget {
  const _PuzzleBody({required this.puzzle});

  final Puzzle puzzle;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          '${puzzle.placed} von ${puzzle.placeable} Teilen gelegt',
          style: text.titleLarge,
        ),
        const SizedBox(height: 4),
        Text(
          'Du bist im ${districtName(puzzle.here)}. Entdecke 80 % der Wege '
          'eines Viertels, dann bekommst du sein Abzeichen. Tippe ein Teil '
          'an, um seine Straßen zu sehen.',
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: Puzzle.side,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: [
            for (final piece in puzzle.pieces)
              PuzzlePiece(
                state: piece,
                here: piece.district == puzzle.here,
                onTap: () => showDistrictSheet(context, puzzle, piece),
              ),
          ],
        ),
      ],
    );
  }
}

class _Message extends StatelessWidget {
  const _Message(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Text(text, textAlign: TextAlign.center),
    ),
  );
}
