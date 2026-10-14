import 'package:flutter_test/flutter_test.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/scent/data/drift_scent_repository.dart';
import 'package:wandoo/features/scent/data/in_memory_scent_repository.dart';
import 'package:wandoo/features/scent/scent.dart';

import '../../../support/test_database.dart';

void main() {
  final repos = <String, ScentRepository Function()>{
    'Datenbank': () => DriftScentRepository(testDatabase()),
    'Speicher': InMemoryScentRepository.new,
  };
  for (final MapEntry(key: name, value: make) in repos.entries) {
    test('$name: merkt sich eine Spur und vergisst sie wieder', () async {
      final repo = make();
      expect(await repo.load(), isNull);
      final scent = Scent(
        target: const GeoPoint(52.1, 7.2),
        environment: EnvironmentType.forest,
        createdAt: DateTime(2026, 10, 14, 9),
      );
      await repo.save(scent);
      final again = await repo.load();
      expect(again!.target, scent.target);
      expect(again.environment, EnvironmentType.forest);
      expect(again.createdAt, scent.createdAt);
      await expectLater(repo.watch(), emits(isNotNull));
      await repo.clear();
      expect(await repo.load(), isNull);
    });
  }
}
