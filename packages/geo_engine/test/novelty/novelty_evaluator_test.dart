import 'package:geo_engine/geo_engine.dart';
import 'package:test/test.dart';

void main() {
  test('trennt neue von bekannten Abschnitten', () {
    final result = const NoveltyEvaluator().evaluate(
      walked: {'a', 'b', 'c'},
      known: {'b', 'x'},
    );
    expect(result.newIds, {'a', 'c'});
    expect(result.knownIds, {'b'});
    expect(result.hasNews, isTrue);
  });

  test('bekannter Weg bringt nichts Neues', () {
    final result = const NoveltyEvaluator().evaluate(
      walked: {'b'},
      known: {'b'},
    );
    expect(result.hasNews, isFalse);
  });
}
