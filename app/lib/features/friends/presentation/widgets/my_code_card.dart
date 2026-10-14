import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wandoo/features/friends/domain/friend_card.dart';

/// Dein Freundes-Code zum Zeigen. Er verrät keinen Namen und keinen Ort.
class MyCodeCard extends StatelessWidget {
  const MyCodeCard({required this.card, super.key});

  final FriendCard card;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text('Dein Code', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ColoredBox(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: QrImageView(
                key: const Key('my-code'),
                data: card.encode(),
                size: 180,
                padding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Zeig ihn deinem Freund. Er scannt ihn in seiner Wandoo-App. '
            'Dein Name und dein Ort stehen nicht drin.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
