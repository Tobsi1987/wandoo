import 'package:drift/drift.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/core/database/app_database.dart';
import 'package:wandoo/features/scent/domain/scent.dart';
import 'package:wandoo/features/scent/domain/scent_repository.dart';

/// Speichert die Spur in der lokalen Datenbank (höchstens eine Zeile).
class DriftScentRepository implements ScentRepository {
  DriftScentRepository(this._db);

  final AppDatabase _db;
  static const _rowId = 1;

  @override
  Future<Scent?> load() async => _toScent(await _query().getSingleOrNull());

  @override
  Stream<Scent?> watch() => _query().watchSingleOrNull().map(_toScent);

  @override
  Future<void> save(Scent scent) => _db
      .into(_db.scentStates)
      .insertOnConflictUpdate(
        ScentStatesCompanion.insert(
          id: const Value(_rowId),
          latitude: scent.target.latitude,
          longitude: scent.target.longitude,
          environment: Value(scent.environment?.name),
          createdAt: scent.createdAt,
        ),
      );

  @override
  Future<void> clear() =>
      (_db.delete(_db.scentStates)..where((t) => t.id.equals(_rowId))).go();

  SimpleSelectStatement<$ScentStatesTable, ScentState> _query() =>
      _db.select(_db.scentStates)..where((t) => t.id.equals(_rowId));

  static Scent? _toScent(ScentState? row) {
    if (row == null) return null;
    return Scent(
      target: GeoPoint(row.latitude, row.longitude),
      environment: EnvironmentType.values.asNameMap()[row.environment],
      createdAt: row.createdAt,
    );
  }
}
