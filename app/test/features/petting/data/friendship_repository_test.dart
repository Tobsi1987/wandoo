import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/petting/data/drift_friendship_repository.dart';
import 'package:wandoo/features/petting/data/in_memory_friendship_repository.dart';
import 'package:wandoo/features/petting/petting.dart';

import '../../../support/test_database.dart';

void main() {
  final repos = <String, FriendshipRepository Function()>{
    'Datenbank': () => DriftFriendshipRepository(testDatabase()),
    'Speicher': InMemoryFriendshipRepository.new,
  };
  for (final MapEntry(key: name, value: make) in repos.entries) {
    test(
      '$name: merkt sich Punkte, ein neues Wesen fängt bei null an',
      () async {
        final repo = make();
        await repo.save(
          Friendship(
            creatureKey: 'a',
            points: 12,
            petsToday: 2,
            petDay: DateTime(2026, 10, 13),
          ),
        );
        final again = await repo.load('a');
        expect(again.points, 12);
        expect(again.petsToday, 2);
        expect(again.petDay, DateTime(2026, 10, 13));
        expect((await repo.load('b')).points, 0);
        expect((await repo.watch('a').first).points, 12);
      },
    );
  }
}
