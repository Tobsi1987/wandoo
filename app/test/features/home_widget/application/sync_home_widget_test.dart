import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/home_widget/home_widget.dart';

class _RecordingPublisher implements WidgetPublisher {
  final published = <WidgetSnapshot>[];
  bool fail = false;

  @override
  Future<void> publish(WidgetSnapshot snapshot) async {
    if (fail) throw StateError('kein Widget');
    published.add(snapshot);
  }
}

void main() {
  final now = DateTime(2026, 10, 13, 12);
  late _RecordingPublisher publisher;
  late SyncHomeWidget sync;

  setUp(() {
    publisher = _RecordingPublisher();
    sync = SyncHomeWidget(publisher, clock: () => now);
  });

  test('ein frisches Ei wartet auf den ersten Gang', () async {
    await sync(const Creature());
    expect(publisher.published.single.toMap(), {
      'face': '🥚',
      'stage': 'Ei',
      'detail': '0 neue Wege',
      'mood': 'wartet auf den ersten Gang',
    });
  });

  test('zeigt Stufe, Merkmal und Laune', () async {
    await sync(
      Creature(food: 42, traitPoints: {Trait.fins: 9}, lastFedAt: now),
    );
    final snapshot = publisher.published.single;
    expect(snapshot.stage, 'Jungtier');
    expect(snapshot.detail, '42 neue Wege · viel Flossen');
    expect(snapshot.mood, 'ist satt und munter');
  });

  test('ein lange nicht gefüttertes Wesen döst', () async {
    await sync(Creature(food: 1, lastFedAt: DateTime(2026, 10, 2)));
    expect(publisher.published.single.detail, '1 neuer Weg');
    expect(publisher.published.single.mood, 'döst und wartet auf Neues');
  });

  test('Fehler der Plattform bringen die App nicht zu Fall', () async {
    publisher.fail = true;
    await expectLater(sync(const Creature()), completes);
  });
}
