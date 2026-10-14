import 'package:wandoo/features/walk_summary/domain/walk_summary.dart';

/// Was eine Seite der Zusammenfassung zeigt.
enum SummaryPageKind { overview, news, levels }

/// Eine Seite nach dem Gang: erst die Zahlen, dann was unterwegs passiert
/// ist, zuletzt Level-Aufstiege. Leere Seiten fallen weg.
class SummaryPage {
  const SummaryPage(this.kind, [this.lines = const []]);

  final SummaryPageKind kind;
  final List<String> lines;
}

const _levelMarks = ['⬆️', '🌟', '🥚'];

bool _isLevel(String line) => _levelMarks.any(line.startsWith);

List<SummaryPage> summaryPages(WalkSummary summary) {
  final news = [
    if (summary.creatureGrew) '🌱 Dein Wesen ist gewachsen!',
    ...summary.extraLines.where((l) => !_isLevel(l)),
  ];
  final levels = summary.extraLines.where(_isLevel).toList();
  return [
    const SummaryPage(SummaryPageKind.overview),
    if (news.isNotEmpty) SummaryPage(SummaryPageKind.news, news),
    if (levels.isNotEmpty) SummaryPage(SummaryPageKind.levels, levels),
  ];
}

/// Teilt "🌺 3 Mohnblumen" in Symbol und Text.
(String, String) splitIcon(String line) {
  final space = line.indexOf(' ');
  if (space <= 0 || space > 8) return ('', line);
  return (line.substring(0, space), line.substring(space + 1));
}
