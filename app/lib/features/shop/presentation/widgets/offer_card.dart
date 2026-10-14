import 'package:flutter/material.dart';
import 'package:wandoo/features/shop/domain/shop_offer.dart';

/// Ein Angebot: Bild, was es tut, Preis und Knopf.
class OfferCard extends StatelessWidget {
  const OfferCard({required this.offer, required this.onBuy, super.key});

  final ShopOffer offer;
  final VoidCallback onBuy;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final blocked = offer.blockedBecause;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(offer.emoji, style: const TextStyle(fontSize: 36)),
                const SizedBox(width: 12),
                Expanded(child: Text(offer.title, style: text.titleMedium)),
              ],
            ),
            const SizedBox(height: 8),
            Text(offer.text, style: text.bodyMedium),
            const SizedBox(height: 12),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 8,
              children: [
                FilledButton(
                  key: Key('buy-${offer.id}'),
                  onPressed: blocked == null ? onBuy : null,
                  child: Text(offer.free ? 'Gratis holen' : offer.price),
                ),
                if (blocked ?? offer.note case final hint?)
                  Text(hint, style: text.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
