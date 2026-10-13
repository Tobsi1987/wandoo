import 'package:drift/drift.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/core/database/app_database.dart';
import 'package:wandoo/features/tracking/domain/recorded_walk_repository.dart';

/// Speichert Gänge als GPX in der lokalen Datenbank.
class DriftRecordedWalkRepository implements RecordedWalkRepository {
  DriftRecordedWalkRepository(this._db, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _clock;

  @override
  Future<void> saveFinished(Track track) => _save(track, finished: true);

  @override
  Future<void> saveProgress(Track track) => _save(track, finished: false);

  Future<void> _save(Track track, {required bool finished}) => _db
      .into(_db.recordedWalks)
      .insertOnConflictUpdate(
        RecordedWalksCompanion.insert(
          id: track.id,
          startedAt: track.startedAt ?? _clock(),
          gpx: GpxCodec.encode(track),
          finished: Value(finished),
        ),
      );

  @override
  Future<Track?> unfinished() async {
    final query = _db.select(_db.recordedWalks)
      ..where((t) => t.finished.equals(false))
      ..orderBy([(t) => OrderingTerm.desc(t.startedAt)])
      ..limit(1);
    final row = await query.getSingleOrNull();
    return row == null ? null : GpxCodec.decode(row.gpx, id: row.id);
  }

  @override
  Future<void> discard(String trackId) =>
      (_db.delete(_db.recordedWalks)..where((t) => t.id.equals(trackId))).go();

  @override
  Future<List<Track>> pending() async {
    final rows = await _pendingQuery().get();
    return [for (final r in rows) GpxCodec.decode(r.gpx, id: r.id)];
  }

  @override
  Stream<int> watchPendingCount() =>
      _pendingQuery().watch().map((rows) => rows.length);

  @override
  Future<void> markProcessed(String trackId) =>
      (_db.update(_db.recordedWalks)..where((t) => t.id.equals(trackId))).write(
        RecordedWalksCompanion(processedAt: Value(_clock())),
      );

  SimpleSelectStatement<$RecordedWalksTable, RecordedWalk> _pendingQuery() =>
      _db.select(_db.recordedWalks)
        ..where((t) => t.processedAt.isNull() & t.finished.equals(true))
        ..orderBy([(t) => OrderingTerm.asc(t.startedAt)]);
}
