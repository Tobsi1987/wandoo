import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/creature/data/in_memory_creature_repository.dart';
import 'package:wandoo/features/discovery/data/in_memory_known_segments_repository.dart';
import 'package:wandoo/features/shop/data/in_memory_shop_repository.dart';
import 'package:wandoo/flows/shop/shop_offers.dart';

void main() {
  final now = DateTime(2026, 10, 14, 12);
  final paused = Creature(
    lastReleasedAt: now.subtract(const Duration(days: 2)),
  );

  test(
    'Pause beenden: nur bei Pause, danach darf wieder eines gehen',
    () async {
      final creatures = InMemoryCreatureRepository(paused);
      final offers = ShopOffers(
        creatures: creatures,
        known: InMemoryKnownSegmentsRepository(),
        shop: InMemoryShopRepository(),
      );
      final pause = offers(
        creature: paused,
        knownStreets: 0,
        lastFree: null,
        now: now,
      ).first;
      expect(pause.blockedBecause, isNull);
      expect(pause.note, 'Pause: noch 5 Tage');
      await pause.buy();
      expect((await creatures.load()).lastReleasedAt, isNull);
      final none = offers(
        creature: const Creature(),
        knownStreets: 0,
        lastFree: null,
        now: now,
      ).first;
      expect(none.blockedBecause, isNotNull);
    },
  );

  test('Straßen neu: einmal pro Woche gratis', () async {
    final known = InMemoryKnownSegmentsRepository();
    await known.addAll({'a', 'b'});
    final shop = InMemoryShopRepository();
    final offers = ShopOffers(
      creatures: InMemoryCreatureRepository(),
      known: known,
      shop: shop,
    );
    final first = offers(
      creature: null,
      knownStreets: 2,
      lastFree: null,
      now: now,
    ).last;
    expect(first.free, isTrue);
    await first.buy();
    expect(await known.knownIds(), isEmpty);
    expect(shop.current, now);
    final again = offers(
      creature: null,
      knownStreets: 2,
      lastFree: now,
      now: now.add(const Duration(days: 1)),
    ).last;
    expect(again.free, isFalse);
    expect(again.note, 'Gratis wieder in 6 Tagen');
  });
}
