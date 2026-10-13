import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/walk_summary/application/walk_summary_providers.dart';
import 'package:wandoo/features/walk_summary/domain/walk_summary.dart';
import 'package:wandoo/features/walk_summary/presentation/summary_parts.dart';

/// Zeigt, was der letzte Gang gebracht hat: groß die neuen Straßen,
/// darunter die Umgebungen und das Besondere. Verschwindet nach "Weiter".
class WalkSummaryCard extends ConsumerWidget {
  const WalkSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(latestUnseenSummaryProvider).value;
    if (summary == null) return const SizedBox.shrink();
    return Semantics(
      label: 'Dein letzter Gang',
      container: true,
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (summary.foundNothing)
                const KnownWaysHeader()
              else
                NewStreetsHeader(summary: summary),
              ..._details(summary),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => ref
                      .read(walkSummaryRepositoryProvider)
                      .markSeen(summary.walkId),
                  child: const Text('Weiter'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _details(WalkSummary summary) {
    final places = placeChips(summary);
    final news = [
      if (summary.creatureGrew) 'Dein Wesen ist gewachsen!',
      ...summary.extraLines,
    ];
    return [
      if (places.isNotEmpty) ...[
        const SizedBox(height: 12),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          alignment: WrapAlignment.center,
          children: places,
        ),
      ],
      if (news.isNotEmpty) const SizedBox(height: 12),
      for (final line in news) HighlightRow(text: line),
    ];
  }
}
