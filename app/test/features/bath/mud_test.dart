import 'package:flutter_test/flutter_test.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/bath/bath.dart';

void main() {
  int after(
    int level, {
    int meters = 1000,
    Map<EnvironmentType, int> streets = const {},
    bool rainy = false,
  }) => Mud.afterWalk(level, meters: meters, newStreets: streets, rainy: rainy);

  test('Stadtwege ohne Regen machen nicht schmutzig', () {
    expect(after(0, streets: {EnvironmentType.city: 20}), 0);
  });

  test('Wald und Feld machen etwas schmutzig, Regen mehr', () {
    expect(
      after(0, streets: {EnvironmentType.forest: 2, EnvironmentType.field: 1}),
      1,
    );
    expect(after(0, rainy: true), 2);
    expect(
      after(2, streets: {EnvironmentType.forest: 5}, rainy: true),
      Mud.max,
    );
  });

  test('ein paar Schritte vor die Tür zählen nicht', () {
    expect(after(1, meters: 100, rainy: true), 1);
  });
}
