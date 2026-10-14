import 'dart:io';

import 'package:wandoo/core/database/app_database.dart';
import 'package:wandoo/features/privacy/domain/data_wiper.dart';

/// Leert alle Tabellen der Datenbank und die Ordner mit zwischengespeicherten
/// Karten; danach läuft, was sonst noch aufzuräumen ist (Erinnerungen).
class DeviceDataWiper implements DataWiper {
  DeviceDataWiper(this._db, {this.folders = const [], this.alsoRun = const []});

  final AppDatabase _db;

  /// Ordner, deren Inhalt mit gelöscht wird.
  final List<Directory> folders;

  final List<Future<void> Function()> alsoRun;

  @override
  Future<void> wipeAll() async {
    await _db.transaction(() async {
      for (final table in _db.allTables) {
        await _db.delete(table).go();
      }
    });
    for (final folder in folders) {
      if (!folder.existsSync()) continue;
      await for (final entry in folder.list()) {
        await entry.delete(recursive: true);
      }
    }
    for (final run in alsoRun) {
      await run();
    }
  }
}
