import 'package:flutter/material.dart';
import 'package:wandoo/features/walk_summary/domain/summary_pages.dart';
import 'package:wandoo/features/walk_summary/domain/walk_summary.dart';
import 'package:wandoo/features/walk_summary/presentation/summary_parts.dart';

/// Der Inhalt einer Seite, ohne Knopf.
class SummaryPageView extends StatelessWidget {
  const SummaryPageView({required this.page, required this.summary, super.key});

  final SummaryPage page;
  final WalkSummary summary;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final title = switch (page.kind) {
      SummaryPageKind.overview =>
        summary.foundNothing ? 'Dein Wesen ist satt' : 'Toller Gang!',
      SummaryPageKind.news => 'Unterwegs passiert',
      SummaryPageKind.levels => 'Aufgestiegen!',
    };
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        if (page.kind == SummaryPageKind.overview)
          ..._overview(text)
        else
          for (final line in page.lines) _Row(line: line),
      ],
    );
  }

  List<Widget> _overview(TextTheme text) {
    final line = summary.foundNothing
        ? 'Wachsen tut es nur auf neuen Straßen.'
        : placesLine(summary);
    return [
      SummaryStats(summary: summary),
      if (line.isNotEmpty) ...[
        const SizedBox(height: 10),
        Text(line, style: text.bodyMedium, textAlign: TextAlign.center),
      ],
    ];
  }
}

/// Eine ruhige Zeile: Symbol links in einem Kreis, Text daneben.
class _Row extends StatelessWidget {
  const _Row({required this.line});

  final String line;

  @override
  Widget build(BuildContext context) {
    final (icon, label) = splitIcon(line);
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: colors.secondaryContainer,
            child: Text(icon, style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}
