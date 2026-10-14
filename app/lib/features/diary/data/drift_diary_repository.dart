import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/core/database/app_database.dart';
import 'package:wandoo/features/diary/domain/diary.dart';
import 'package:wandoo/features/diary/domain/diary_repository.dart';

/// Speichert die Tagebücher in der lokalen Datenbank.
class DriftDiaryRepository implements DiaryRepository {
  DriftDiaryRepository(this._db);

  final AppDatabase _db;

  @override
  Future<void> add(DiaryWalk walk, List<Memory> memories) =>
      _db.transaction(() async {
        await _db.into(_db.diaryWalks).insertOnConflictUpdate(_walkRow(walk));
        for (final m in memories) {
          await _db.into(_db.diaryMemories).insert(_memoryRow(m));
        }
      });

  @override
  Future<Diary> load(String creatureKey) async => Diary(
    walks: (await _walks(creatureKey).get()).map(_toWalk).toList(),
    memories: (await _memories(creatureKey).get()).map(_toMemory).toList(),
  );

  /// Meldet sich bei jeder Änderung an Gängen oder Erinnerungen neu.
  @override
  Stream<Diary> watch(String creatureKey) async* {
    yield await load(creatureKey);
    yield* _db
        .tableUpdates(
          TableUpdateQuery.onAllTables([_db.diaryWalks, _db.diaryMemories]),
        )
        .asyncMap((_) => load(creatureKey));
  }

  SimpleSelectStatement<$DiaryWalksTable, DiaryWalkRow> _walks(String key) =>
      _db.select(_db.diaryWalks)
        ..where((t) => t.creatureKey.equals(key))
        ..orderBy([(t) => OrderingTerm.asc(t.finishedAt)]);

  SimpleSelectStatement<$DiaryMemoriesTable, DiaryMemoryRow> _memories(
    String key,
  ) => _db.select(_db.diaryMemories)
    ..where((t) => t.creatureKey.equals(key))
    ..orderBy([(t) => OrderingTerm.asc(t.at), (t) => OrderingTerm.asc(t.id)]);

  static DiaryWalksCompanion _walkRow(DiaryWalk w) =>
      DiaryWalksCompanion.insert(
        walkId: w.walkId,
        creatureKey: w.creatureKey,
        finishedAt: w.finishedAt,
        meters: w.meters,
        path: jsonEncode([
          for (final p in w.path) [_round(p.latitude), _round(p.longitude)],
        ]),
      );

  static DiaryMemoriesCompanion _memoryRow(Memory m) =>
      DiaryMemoriesCompanion.insert(
        creatureKey: m.creatureKey,
        at: m.at,
        emoji: m.emoji,
        title: m.title,
        latitude: Value(m.place?.latitude),
        longitude: Value(m.place?.longitude),
      );

  static DiaryWalk _toWalk(DiaryWalkRow row) => DiaryWalk(
    walkId: row.walkId,
    creatureKey: row.creatureKey,
    finishedAt: row.finishedAt,
    meters: row.meters,
    path: [
      for (final p in jsonDecode(row.path) as List<dynamic>)
        GeoPoint(
          ((p as List<dynamic>)[0] as num).toDouble(),
          (p[1] as num).toDouble(),
        ),
    ],
  );

  static Memory _toMemory(DiaryMemoryRow row) => Memory(
    creatureKey: row.creatureKey,
    at: row.at,
    emoji: row.emoji,
    title: row.title,
    place: row.latitude != null && row.longitude != null
        ? GeoPoint(row.latitude!, row.longitude!)
        : null,
  );

  /// Fünf Nachkommastellen sind etwa ein Meter.
  static double _round(double v) => (v * 1e5).roundToDouble() / 1e5;
}
