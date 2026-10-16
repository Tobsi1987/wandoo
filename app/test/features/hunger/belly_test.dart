import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/hunger/data/drift_belly_repository.dart';
import 'package:wandoo/features/hunger/hunger.dart';

import '../../support/test_database.dart';

final _start = DateTime(2026, 10, 14, 12);

void main() {
  test('5 km voll, jeden Tag 1 km weniger, Gehen füllt auf', () {
    final belly = Belly.full('erstes', _start);
    expect(belly.fillAt(_start), 1);
    final later = _start.add(const Duration(days: 3));
    expect(belly.metersAt(later), 2000);
    expect(belly.eat(1500, later).metersAt(later), 3500);
    expect(belly.eat(9000, later).metersAt(later), Belly.fullMeters);
  });

  test('nach 5 Tagen leer, nach 7 Tagen zieht das Wesen aus', () {
    final belly = Belly.full('erstes', _start);
    expect(belly.emptyAt, _start.add(const Duration(days: 5)));
    expect(belly.isEmpty(_start.add(const Duration(days: 4))), isFalse);
    expect(belly.isEmpty(_start.add(const Duration(days: 5))), isTrue);
    expect(belly.leavesBy(_start.add(const Duration(days: 6))), isFalse);
    expect(belly.leavesBy(_start.add(const Duration(days: 7))), isTrue);
  });

  test('langsamer hungrig: mit 0.9 erst nach 5,5 Tagen leer', () {
    final belly = Belly.full('erstes', _start).slowed(0.9);
    final empty = belly.emptyAt.difference(_start).inHours;
    expect(empty, closeTo(5000 / 900 * 24, 1));
    final later = _start.add(const Duration(days: 1));
    expect(belly.metersAt(later), closeTo(4100, 1));
    expect(belly.eat(100, later).drain, 0.9);
  });

  test('Datenbank merkt sich Balken und Brief', () async {
    final repo = DriftBellyRepository(testDatabase());
    expect(await repo.load('erstes'), isNull);
    await repo.save(Belly(lineKey: 'erstes', meters: 1234, at: _start));
    final loaded = await repo.load('erstes');
    expect(loaded?.meters, 1234);
    expect(loaded?.at, _start);
    await repo.leaveLetter(Farewell(speciesId: 'moosel', at: _start));
    expect((await repo.watchLetter().first)?.speciesId, 'moosel');
    await repo.leaveLetter(null);
    expect(await repo.watchLetter().first, isNull);
  });
}
