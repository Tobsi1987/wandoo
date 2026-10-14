import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/discovery/discovery.dart';
import 'package:wandoo/features/shop/shop.dart';

/// Baut die Angebote des Ladens aus dem Zustand von Wesen und Straßen.
class ShopOffers {
  ShopOffers({
    required this.creatures,
    required this.known,
    required this.shop,
  });

  final CreatureRepository creatures;
  final KnownSegmentsRepository known;
  final ShopRepository shop;

  static const _release = ReleaseCreature();
  static const _free = FreeRediscover();

  List<ShopOffer> call({
    required Creature? creature,
    required int knownStreets,
    required DateTime? lastFree,
    required DateTime now,
  }) => [_endPause(creature, now), _rediscover(knownStreets, lastFree, now)];

  ShopOffer _endPause(Creature? creature, DateTime now) {
    final wait = creature == null
        ? Duration.zero
        : _release.waitLeft(creature, now);
    return ShopOffer(
      id: 'pause',
      emoji: '🧳',
      title: 'Wegschick-Pause beenden',
      text:
          'Nach dem Wegschicken musst du 7 Tage warten, bis wieder ein '
          'Wesen gehen darf. Das hier beendet die Pause sofort.',
      price: '0,99 €',
      note: wait == Duration.zero ? null : 'Pause: noch ${_days(wait)}',
      blockedBecause: wait == Duration.zero
          ? 'Gerade gibt es keine Pause.'
          : null,
      buy: () async {
        await creatures.save(_release.endPause(await creatures.load()));
        return 'Die Pause ist vorbei.';
      },
    );
  }

  ShopOffer _rediscover(int knownStreets, DateTime? lastFree, DateTime now) {
    final wait = _free.waitLeft(lastFree, now);
    return ShopOffer(
      id: 'streets',
      emoji: '🗺️',
      title: 'Straßen neu entdecken',
      text:
          'Alle ${knownStreets > 0 ? '$knownStreets ' : ''}bekannten '
          'Straßen werden wieder neu. So kann '
          'dein Wesen auf alten Wegen wieder wachsen. Einmal pro Woche '
          'gratis.',
      price: '1,99 €',
      free: wait == null,
      note: wait == null
          ? null
          : 'Gratis wieder in ${_days(wait, dative: true)}',
      blockedBecause: knownStreets == 0 ? 'Du kennst noch keine Straße.' : null,
      buy: () async {
        await known.forgetAll();
        if (wait == null) await shop.saveLastFreeRediscover(now);
        return 'Alle Straßen sind wieder neu. Los, entdecken!';
      },
    );
  }

  static String _days(Duration d, {bool dative = false}) {
    final days = (d.inHours / 24).ceil();
    if (days <= 1) return '1 Tag';
    return dative ? '$days Tagen' : '$days Tage';
  }
}
