import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/diary/domain/diary.dart';

/// Was über einen Gang bekannt ist, ohne dass das Tagebuch das Wesen
/// kennen muss (das verbindet `flows/process_walk`).
class WalkFacts {
  const WalkFacts({
    required this.walkId,
    required this.creatureKey,
    required this.finishedAt,
    required this.track,
    required this.metersBefore,
    required this.metersAfter,
    this.firstWalk = false,
    this.withEgg = false,
    this.hatched = false,
    this.grewTo,
  });

  final String walkId;
  final String creatureKey;
  final DateTime finishedAt;
  final List<GeoPoint> track;

  /// Wie weit das Wesen vorher und nachher insgesamt gelaufen war.
  final int metersBefore;
  final int metersAfter;

  /// Der erste Gang dieses Wesens; [withEgg], wenn es noch ein Ei war.
  final bool firstWalk;
  final bool withEgg;

  /// Auf diesem Gang geschlüpft.
  final bool hatched;

  /// Neue Stufe, falls es auf diesem Gang gewachsen ist (z. B. "Jungtier").
  final String? grewTo;
}

/// Macht aus einem Gang einen Tagebucheintrag und findet die Momente, an
/// die man sich erinnern will.
class RememberWalk {
  const RememberWalk({
    this.milestonesKm = const [1, 5, 10, 25, 50, 100, 250, 500],
    this.maxPoints = 150,
  });

  final List<int> milestonesKm;

  /// So viele Punkte bleiben höchstens von einer Spur.
  final int maxPoints;

  DiaryWalk walk(WalkFacts f) => DiaryWalk(
    walkId: f.walkId,
    creatureKey: f.creatureKey,
    finishedAt: f.finishedAt,
    meters: f.metersAfter - f.metersBefore,
    path: thin(f.track),
  );

  List<Memory> memories(WalkFacts f) {
    final start = f.track.firstOrNull;
    final end = f.track.lastOrNull;
    Memory at(GeoPoint? place, String emoji, String title) => Memory(
      creatureKey: f.creatureKey,
      at: f.finishedAt,
      emoji: emoji,
      title: title,
      place: place,
    );
    return [
      if (f.firstWalk && f.withEgg)
        at(start, '🥚', 'Erster Ausflug mit dem Ei'),
      if (f.firstWalk && !f.withEgg)
        at(start, '👣', 'Unser erster gemeinsamer Gang'),
      if (f.hatched) at(end, '🐣', 'Hier bist du geschlüpft'),
      if (f.grewTo case final stage?) at(end, '🌱', 'Gewachsen: $stage'),
      for (final km in milestonesKm)
        if (f.metersBefore < km * 1000 && f.metersAfter >= km * 1000)
          at(end, '🏅', 'Zusammen $km km gelaufen'),
    ];
  }

  /// Dünnt eine Spur gleichmäßig aus; Anfang und Ende bleiben.
  List<GeoPoint> thin(List<GeoPoint> track) {
    if (track.length <= maxPoints) return track;
    final step = (track.length - 1) / (maxPoints - 1);
    return [for (var i = 0; i < maxPoints; i++) track[(i * step).round()]];
  }
}
