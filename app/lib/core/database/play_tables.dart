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

/// Einstellungen als Schlüssel und Wert, z. B. `sounds.muted` (seit
/// Schema 12).
class Preferences extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}
