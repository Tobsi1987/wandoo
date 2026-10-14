import 'package:drift/drift.dart';

/// Die Spur, der die Spürnase gerade folgt, höchstens eine Zeile
/// (seit Schema 11).
class ScentStates extends Table {
  IntColumn get id => integer()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();

  /// Name der Umgebung (`EnvironmentType.name`), falls bekannt.
  TextColumn get environment => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
