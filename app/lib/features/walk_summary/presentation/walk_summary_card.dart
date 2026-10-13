import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/walk_summary/application/walk_summary_providers.dart';
import 'package:wandoo/features/walk_summary/domain/summary_lines.dart';

/// Zeigt, was der letzte Gang gebracht hat. Verschwindet nach "Weiter".
class WalkSummaryCard extends ConsumerWidget {
  const WalkSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(latestUnseenSummaryProvider).value;
    if (summary == null) return const SizedBox.shrink();
    final text = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dein letzter Gang', style: text.titleMedium),
            const SizedBox(height: 8),
            for (final line in summaryLines(summary))
              Text(line, style: text.bodyLarge),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => ref
                    .read(walkSummaryRepositoryProvider)
                    .markSeen(summary.walkId),
                child: const Text('Weiter'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
