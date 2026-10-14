import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/walk_summary/application/walk_summary_providers.dart';
import 'package:wandoo/features/walk_summary/domain/summary_pages.dart';
import 'package:wandoo/features/walk_summary/domain/walk_summary.dart';
import 'package:wandoo/features/walk_summary/presentation/summary_page_view.dart';

/// Zeigt nach einem Gang, was er gebracht hat, Seite für Seite: erst die
/// Zahlen, dann was unterwegs passiert ist, dann Level. "Weiter" blättert,
/// auf der letzten Seite schließt "Fertig".
class WalkSummaryCard extends ConsumerWidget {
  const WalkSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(latestUnseenSummaryProvider).value;
    if (summary == null) return const SizedBox.shrink();
    return _Pages(
      key: ValueKey(summary.walkId),
      summary: summary,
      onDone: () =>
          ref.read(walkSummaryRepositoryProvider).markSeen(summary.walkId),
    );
  }
}

class _Pages extends StatefulWidget {
  const _Pages({required this.summary, required this.onDone, super.key});

  final WalkSummary summary;
  final VoidCallback onDone;

  @override
  State<_Pages> createState() => _PagesState();
}

class _PagesState extends State<_Pages> {
  late final List<SummaryPage> _pages = summaryPages(widget.summary);
  var _at = 0;

  bool get _last => _at == _pages.length - 1;

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * 0.5;
    return Semantics(
      label: 'Dein letzter Gang',
      container: true,
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxHeight),
                child: SingleChildScrollView(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: SummaryPageView(
                      key: ValueKey(_at),
                      page: _pages[_at],
                      summary: widget.summary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              if (_pages.length > 1) _Dots(count: _pages.length, at: _at),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _last
                      ? widget.onDone
                      : () => setState(() => _at++),
                  child: Text(_last ? 'Fertig' : 'Weiter'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Kleine Punkte: auf welcher Seite man ist.
class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.at});

  final int count;
  final int at;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return ExcludeSemantics(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < count; i++)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == at ? 18 : 7,
              height: 7,
              decoration: BoxDecoration(
                color: color.withValues(alpha: i == at ? 1 : 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
        ],
      ),
    );
  }
}
