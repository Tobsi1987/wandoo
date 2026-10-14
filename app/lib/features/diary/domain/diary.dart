import 'package:geo_engine/geo_engine.dart';

/// Ein Gang im Tagebuch: wann, wie weit und wo entlang.
class DiaryWalk {
  const DiaryWalk({
    required this.walkId,
    required this.creatureKey,
    required this.finishedAt,
    required this.meters,
    this.path = const [],
  });

  final String walkId;

  /// Zu welchem Wesen der Gang gehört (`Creature.lineKey`).
  final String creatureKey;
  final DateTime finishedAt;
  final int meters;

  /// Ausgedünnte Spur für die Karte.
  final List<GeoPoint> path;
}

/// Ein besonderer Moment, zum Beispiel "Hier bist du geschlüpft".
class Memory {
  const Memory({
    required this.creatureKey,
    required this.at,
    required this.emoji,
    required this.title,
    this.place,
  });

  final String creatureKey;
  final DateTime at;
  final String emoji;
  final String title;

  /// Wo es passiert ist; ohne Ort steht es nur in der Liste.
  final GeoPoint? place;
}

/// Alles, was im Tagebuch eines Wesens steht, ältestes zuerst.
class Diary {
  const Diary({this.walks = const [], this.memories = const []});

  final List<DiaryWalk> walks;
  final List<Memory> memories;

  bool get isEmpty => walks.isEmpty && memories.isEmpty;

  int get meters => walks.fold(0, (sum, w) => sum + w.meters);

  DateTime? get since => walks.firstOrNull?.finishedAt;
}
