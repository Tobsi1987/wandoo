import 'package:wandoo/features/levels/domain/level_curve.dart';

/// Erfahrung eines Wesens vom Schlüpfen bis zum Auszug.
class Progress {
  const Progress({required this.lineKey, this.xp = 0, this.news = const []});

  /// Zu welchem Wesen sie gehört (`Creature.lineKey`).
  final String lineKey;
  final int xp;

  /// Noch nicht gezeigte Level-Nachrichten, zum Beispiel nach dem
  /// Streicheln.
  final List<String> news;

  int get level => LevelCurve.levelFor(xp);
  int get stage => LevelCurve.stageFor(level);
  double get towardNext => LevelCurve.towardNext(xp);

  Progress copyWith({int? xp, List<String>? news}) =>
      Progress(lineKey: lineKey, xp: xp ?? this.xp, news: news ?? this.news);
}
