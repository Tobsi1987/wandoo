import 'package:drift/drift.dart';
import 'package:wandoo/core/database/app_database.dart';
import 'package:wandoo/features/discovery/domain/known_segments_repository.dart';

/// Speichert entdeckte Abschnitte in der lokalen Datenbank.
class DriftKnownSegmentsRepository implements KnownSegmentsRepository {
  DriftKnownSegmentsRepository(this._db, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _clock;

  @override
  Future<Set<String>> knownIds() async {
    final rows = await _db.select(_db.knownSegments).get();
    return {for (final row in rows) row.segmentId};
  }

  @override
  Future<void> addAll(Set<String> ids) async {
    if (ids.isEmpty) return;
    final now = _clock();
    await _db.batch((batch) {
      batch.insertAll(_db.knownSegments, [
        for (final id in ids)
          KnownSegmentsCompanion.insert(segmentId: id, discoveredAt: now),
      ], mode: InsertMode.insertOrIgnore);
    });
  }
}
