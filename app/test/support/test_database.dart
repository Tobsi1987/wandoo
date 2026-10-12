import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:wandoo/core/database/app_database.dart';

/// Frische In-Memory-Datenbank für Tests.
AppDatabase testDatabase() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  return AppDatabase(NativeDatabase.memory());
}
