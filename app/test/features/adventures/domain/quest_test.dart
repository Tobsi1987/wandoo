import 'package:flutter_test/flutter_test.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/adventures/adventures.dart';

void main() {
  const fresh = {EnvironmentType.forest: 3, EnvironmentType.city: 2};

  test('neue Wegstücke zählen alle Umgebungen', () {
    const q = Quest(kind: QuestKind.newSegments, goal: 25);
    expect(q.advance(fresh).progress, 5);
  });

  test('Umgebungs-Abenteuer zählt nur seine Umgebung', () {
    const q = Quest(
      kind: QuestKind.newInEnvironment,
      environment: EnvironmentType.forest,
      goal: 8,
    );
    expect(q.advance(fresh).progress, 3);
  });

  test('Entdeckungstouren zählen nur Gänge mit Neuem', () {
    const q = Quest(kind: QuestKind.discoveryWalks, goal: 3);
    expect(q.advance(fresh).advance({}).progress, 1);
  });

  test('großer Gang zählt nur am Stück', () {
    const q = Quest(kind: QuestKind.bigWalk, goal: 12);
    expect(q.advance(fresh).advance(fresh).done, isFalse);
    expect(q.advance({EnvironmentType.water: 13}).done, isTrue);
  });

  test('Fortschritt bleibt beim Ziel stehen', () {
    const q = Quest(kind: QuestKind.newSegments, goal: 4);
    final done = q.advance(fresh);
    expect(done.progress, 4);
    expect(done.fraction, 1);
  });
}
