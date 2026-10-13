/// Was das Homescreen-Widget gerade zeigt. Reine Texte, damit die native
/// Seite nichts über das Wesen wissen muss.
class WidgetSnapshot {
  const WidgetSnapshot({
    required this.face,
    required this.stage,
    required this.detail,
    required this.mood,
  });

  /// Platzhalter-Gesicht, bis es Grafiken gibt.
  final String face;
  final String stage;
  final String detail;
  final String mood;

  Map<String, String> toMap() => {
    'face': face,
    'stage': stage,
    'detail': detail,
    'mood': mood,
  };
}
