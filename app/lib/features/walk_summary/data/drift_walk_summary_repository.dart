import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/core/database/app_database.dart';
import 'package:wandoo/features/walk_summary/domain/walk_summary.dart';
import 'package:wandoo/features/walk_summary/domain/walk_summary_repository.dart';

/// Speichert Zusammenfassungen in der lokalen Datenbank.
class DriftWalkSummaryRepository implements WalkSummaryRepository {
  DriftWalkSummaryRepository(this._db);

  final AppDatabase _db;

  @override
  Future<void> save(WalkSummary s) => _db
      .into(_db.walkSummaries)
      .insertOnConflictUpdate(
        WalkSummariesCompanion.insert(
          walkId: s.walkId,
          finishedAt: s.finishedAt,
          newSegmentCount: s.newSegmentCount,
          newStreetCount: s.newStreetCount,
          bridgeCount: s.bridgeCount,
          streetsByEnvironment: jsonEncode({
            for (final e in s.streetsByEnvironment.entries) e.key.name: e.value,
          }),
          creatureGrew: s.creatureGrew,
          knownSegmentCount: Value(s.knownSegmentCount),
        ),
      );

  @override
  Stream<WalkSummary?> watchLatestUnseen() {
    final query = _db.select(_db.walkSummaries)
      ..where((t) => t.seen.equals(false))
      ..orderBy([(t) => OrderingTerm.desc(t.finishedAt)])
      ..limit(1);
    return query.watchSingleOrNull().map(
      (r) => r == null ? null : _toSummary(r),
    );
  }

  @override
  Future<void> markSeen(String walkId) =>
      (_db.update(_db.walkSummaries)..where((t) => t.walkId.equals(walkId)))
          .write(const WalkSummariesCompanion(seen: Value(true)));

  static WalkSummary _toSummary(WalkSummaryRow r) {
    final raw = jsonDecode(r.streetsByEnvironment) as Map<String, dynamic>;
    return WalkSummary(
      walkId: r.walkId,
      finishedAt: r.finishedAt,
      newSegmentCount: r.newSegmentCount,
      newStreetCount: r.newStreetCount,
      bridgeCount: r.bridgeCount,
      creatureGrew: r.creatureGrew,
      knownSegmentCount: r.knownSegmentCount,
      streetsByEnvironment: {
        for (final type in EnvironmentType.values)
          if (raw[type.name] is int) type: raw[type.name] as int,
      },
    );
  }
}
