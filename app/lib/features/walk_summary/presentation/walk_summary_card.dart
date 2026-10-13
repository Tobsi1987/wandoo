import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/walk_summary/application/walk_summary_providers.dart';
import 'package:wandoo/features/walk_summary/domain/walk_summary.dart';
import 'package:wandoo/features/walk_summary/presentation/summary_parts.dart';

/// Zeigt, was der letzte Gang gebracht hat: oben zwei große Zahlen,
/// darunter die Umgebungen und als kleine Schilder alles Mitgebrachte.
/// Verschwindet nach "Weiter".
class WalkSummaryCard extends ConsumerWidget {
  const WalkSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(latestUnseenSummaryProvider).value;
    if (summary == null) return const SizedBox.shrink();
    final text = Theme.of(context).textTheme;
    return Semantics(
      label: 'Dein letzter Gang',
      container: true,
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                summary.foundNothing ? 'Dein Wesen ist satt' : 'Toller Gang!',
                style: text.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              SummaryStats(summary: summary),
              ..._places(summary, text),
              ..._news(summary),
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

  List<Widget> _places(WalkSummary summary, TextTheme text) {
    final line = summary.foundNothing
        ? 'Wachsen tut es nur auf neuen Straßen.'
        : placesLine(summary);
    if (line.isEmpty) return const [];
    return [
      const SizedBox(height: 6),
      Text(line, style: text.bodyMedium, textAlign: TextAlign.center),
    ];
  }

  List<Widget> _news(WalkSummary summary) {
    final news = [
      if (summary.creatureGrew) '🌱 Dein Wesen ist gewachsen!',
      ...summary.extraLines,
    ];
    if (news.isEmpty) return const [];
    return [
      const SizedBox(height: 12),
      Wrap(
        spacing: 6,
        runSpacing: 6,
        alignment: WrapAlignment.center,
        children: [for (final line in news) NewsPill(text: line)],
      ),
    ];
  }
}
