import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/treasure/treasure.dart';

class _Always implements Random {
  _Always(this.value);
  final double value;
  @override
  double nextDouble() => value;
  @override
  int nextInt(int max) => 0;
  @override
  bool nextBool() => false;
}

void main() {
  test('ohne neue Wege gibt es nichts', () {
    expect(const DropFinds()({}, _Always(0)), isEmpty);
  });

  test('jeder neue Waldweg kann eine Eichel bringen', () {
    final found = const DropFinds()({EnvironmentType.forest: 3}, _Always(0.1));
    expect(found, [Find.acorn, Find.acorn, Find.acorn]);
  });

  test('Pech heißt: nichts gefunden', () {
    expect(
      const DropFinds()({EnvironmentType.water: 5}, _Always(0.9)),
      isEmpty,
    );
  });

  test('ganz selten ein Sternsplitter', () {
    final found = const DropFinds()({EnvironmentType.city: 1}, _Always(0.005));
    expect(found, [Find.starShard]);
  });

  test('höchstens sechs Funde pro Gang', () {
    final found = const DropFinds()({EnvironmentType.field: 50}, _Always(0.1));
    expect(found, hasLength(6));
  });
}
