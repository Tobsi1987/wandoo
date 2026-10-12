/// Ergebnis der Neuheitsprüfung für einen Gang.
class NoveltyResult {
  const NoveltyResult({required this.newIds, required this.knownIds});

  /// Abschnitte, die heute zum ersten Mal begangen wurden.
  final Set<String> newIds;

  /// Abschnitte, die schon bekannt waren.
  final Set<String> knownIds;

  bool get hasNews => newIds.isNotEmpty;
}
