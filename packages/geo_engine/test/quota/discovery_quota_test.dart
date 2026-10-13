import 'package:geo_engine/geo_engine.dart';
import 'package:test/test.dart';

import '../support/fixtures.dart';

void main() {
  final town = Fixtures.town();

  test('nichts bekannt ergibt 0, alles bekannt ergibt 1', () {
    expect(const DiscoveryQuota().compute(town, {}), 0);
    expect(
      const DiscoveryQuota().compute(town, {for (final s in town) s.id}),
      closeTo(1, 1e-9),
    );
  });

  test('vier von vierzig gleich langen Abschnitten sind zehn Prozent', () {
    final quota = const DiscoveryQuota().compute(town, {
      'h2-0',
      'h2-1',
      'h2-2',
      'h2-3',
    });
    expect(quota, closeTo(0.1, 0.001));
  });

  test('leeres Gebiet ergibt 0', () {
    expect(const DiscoveryQuota().compute(const [], {'x'}), 0);
  });
}
