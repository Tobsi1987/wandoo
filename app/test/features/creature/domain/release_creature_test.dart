import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/creature/creature.dart';

void main() {
  final now = DateTime(2026, 10, 13, 12);
  const release = ReleaseCreature();
  const grown = Creature(food: 30, speciesId: 'pfuetzling');

  test('ein geschlüpftes Wesen geht, ein neues Ei kommt', () {
    final egg = release(grown, now);
    expect(egg.stage, GrowthStage.egg);
    expect(egg.speciesId, isNull);
    expect(egg.lastReleasedAt, now);
  });

  test('das Album bleibt beim Wegschicken erhalten', () {
    final seen = grown.copyWith(seenSpecies: {'pfuetzling', 'moosel'});
    expect(release(seen, now).seenSpecies, {'pfuetzling', 'moosel'});
  });

  test('ein Ei kann man nicht wegschicken', () {
    expect(release.canRelease(const Creature(), now), isFalse);
  });

  test('danach 7 Tage Pause', () {
    final egg = release(grown, now);
    final hatchedAgain = egg.copyWith(food: 30, speciesId: 'moosel');
    final later = now.add(const Duration(days: 6));
    expect(release.canRelease(hatchedAgain, later), isFalse);
    expect(release.waitLeft(hatchedAgain, later), const Duration(days: 1));
    expect(
      release.canRelease(hatchedAgain, now.add(const Duration(days: 7))),
      isTrue,
    );
  });
}
