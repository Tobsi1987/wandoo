import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/core/database/preference_store.dart';
import 'package:wandoo/features/privacy/data/device_data_wiper.dart';

import '../../support/test_database.dart';

void main() {
  test('leert Datenbank und Ordner und räumt den Rest auf', () async {
    final db = testDatabase();
    addTearDown(db.close);
    final store = PreferenceStore(db);
    await store.put('creature.marks', 'false');
    final folder = Directory.systemTemp.createTempSync('wipe');
    addTearDown(() => folder.deleteSync(recursive: true));
    File('${folder.path}/kachel.json').writeAsStringSync('{}');
    var cancelled = false;
    await DeviceDataWiper(
      db,
      folders: [folder],
      alsoRun: [() async => cancelled = true],
    ).wipeAll();
    expect(await store.get('creature.marks'), isNull);
    expect(folder.listSync(), isEmpty);
    expect(cancelled, isTrue);
  });
}
