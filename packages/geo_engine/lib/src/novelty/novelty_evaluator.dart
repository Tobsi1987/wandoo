import 'package:geo_engine/src/novelty/novelty_result.dart';

/// Entscheidet, welche begangenen Abschnitte neu sind.
///
/// Hier landen später Regeln wie "Verwildern" (eine Straße zählt nach
/// Monaten wieder als halb neu) oder Jahreszeiten, ohne dass sich
/// Aufrufer ändern müssen.
class NoveltyEvaluator {
  const NoveltyEvaluator();

  NoveltyResult evaluate({
    required Set<String> walked,
    required Set<String> known,
  }) {
    return NoveltyResult(
      newIds: walked.difference(known),
      knownIds: walked.intersection(known),
    );
  }
}
