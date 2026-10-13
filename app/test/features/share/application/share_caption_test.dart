import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/share/application/share_caption.dart';

void main() {
  test('beschreibt ein frisches Ei', () {
    expect(
      shareCaption(const Creature()),
      'Mein Wandoo-Wesen ist noch ein Ei. 0 neue Wege entdeckt.',
    );
  });

  test('nennt Stufe und stärkstes Merkmal', () {
    const creature = Creature(
      food: 42,
      traitPoints: {Trait.moss: 30, Trait.fins: 12},
    );
    expect(
      shareCaption(creature),
      'Mein Wandoo-Wesen ist jetzt Jungtier mit viel Moos. '
      '42 neue Wege entdeckt.',
    );
  });
}
