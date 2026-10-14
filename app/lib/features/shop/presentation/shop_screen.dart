import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/shop/application/shop_providers.dart';
import 'package:wandoo/features/shop/domain/shop_offer.dart';
import 'package:wandoo/features/shop/presentation/widgets/offer_card.dart';

/// Der Laden. Noch ein Entwurf: Kaufen ist nur gespielt.
class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  static const path = '/laden';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offers = ref.watch(shopOffersProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Laden')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Card(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'Entwurf: Hier wird noch nichts bezahlt. Jeder Kauf ist '
                'ein Probekauf und kostet nichts.',
              ),
            ),
          ),
          for (final offer in offers)
            OfferCard(
              offer: offer,
              onBuy: () => unawaited(_buy(context, offer)),
            ),
        ],
      ),
    );
  }

  static Future<void> _buy(BuildContext context, ShopOffer offer) async {
    final sure = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(offer.title),
        content: Text(
          offer.free
              ? offer.text
              : '${offer.text}\n\nIn der fertigen App kostet das '
                    '${offer.price}. Jetzt ist es ein Probekauf.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            key: const Key('buy-yes'),
            onPressed: () => Navigator.pop(context, true),
            child: Text(offer.free ? 'Holen' : 'Probekauf'),
          ),
        ],
      ),
    );
    if (sure != true) return;
    final done = await offer.buy();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(done)));
  }
}
