import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/petting/petting.dart';

void main() {
  const rules = BefriendCreature();
  const fresh = Friendship(creatureKey: 'erstes');

  test('Streicheln zählt fünfmal am Tag, am nächsten Tag wieder', () {
    var f = fresh;
    final day = DateTime(2026, 10, 13, 9);
    for (var i = 0; i < 8; i++) {
      f = rules.pet(f, day.add(Duration(minutes: i)));
    }
    expect(f.points, 5);
    f = rules.pet(f, DateTime(2026, 10, 14, 8));
    expect(f.points, 6);
    expect(f.petsToday, 1);
  });

  test('ein gemeinsamer Gang zählt drei Punkte', () {
    expect(rules.walked(fresh).points, 3);
  });

  test('Herzen bei 10, 30, 60, 100 und 160 Punkten', () {
    Friendship at(int p) => Friendship(creatureKey: 'x', points: p);
    expect([0, 9, 10, 29, 30, 100, 159, 160, 500].map((p) => at(p).hearts), [
      0,
      0,
      1,
      1,
      2,
      4,
      4,
      5,
      5,
    ]);
    expect(at(5).towardNext, 0.5);
    expect(at(20).towardNext, 0.5);
    expect(at(200).towardNext, 1);
  });
}
