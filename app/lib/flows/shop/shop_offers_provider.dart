import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/discovery/discovery.dart';
import 'package:wandoo/features/shop/shop.dart';
import 'package:wandoo/flows/shop/shop_offers.dart';

final _knownCountProvider = StreamProvider<int>(
  (ref) => ref
      .watch(knownSegmentsRepositoryProvider)
      .watchKnownIds()
      .map((ids) => ids.length),
);

/// Die Angebote, wie sie gerade sind. Der Bootstrap hängt das in
/// `shopOffersProvider` ein.
final liveShopOffersProvider = Provider<List<ShopOffer>>((ref) {
  final build = ShopOffers(
    creatures: ref.watch(creatureRepositoryProvider),
    known: ref.watch(knownSegmentsRepositoryProvider),
    shop: ref.watch(shopRepositoryProvider),
  );
  return build(
    creature: ref.watch(creatureProvider).value,
    knownStreets: ref.watch(_knownCountProvider).value ?? 0,
    lastFree: ref.watch(lastFreeRediscoverProvider),
    now: DateTime.now(),
  );
});
