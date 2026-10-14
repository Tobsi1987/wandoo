import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/friends/application/friends_providers.dart';
import 'package:wandoo/features/friends/domain/friend.dart';
import 'package:wandoo/features/friends/domain/friend_card.dart';
import 'package:wandoo/features/friends/presentation/widgets/add_friend.dart';
import 'package:wandoo/features/friends/presentation/widgets/my_code_card.dart';

/// Dein Code, Freunde hinzufügen und die Liste deiner Freunde.
class FriendsView extends ConsumerWidget {
  const FriendsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final me = ref.watch(myCardProvider);
    final friends = ref.watch(friendsProvider);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        if (me != null) MyCodeCard(card: me),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 4,
          children: [
            FilledButton.icon(
              key: const Key('scan-friend'),
              onPressed: () => unawaited(_add(context, ref, scanFriend)),
              icon: const Icon(Icons.qr_code_scanner_rounded),
              label: const Text('Freund scannen'),
            ),
            TextButton(
              key: const Key('paste-friend'),
              onPressed: () => unawaited(_add(context, ref, pasteFriend)),
              child: const Text('Code einfügen'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        for (final f in friends) _tile(context, ref, f),
        const SizedBox(height: 8),
        Text(
          'Die Zahlen deiner Freunde sind vom letzten Scan. Scannt euch '
          'wieder, dann seht ihr den neuen Stand.',
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _tile(BuildContext context, WidgetRef ref, Friend f) => ListTile(
    leading: const Icon(Icons.person_rounded),
    title: Text(f.name),
    subtitle: Text('Stand vom ${f.card.at.day}.${f.card.at.month}.'),
    trailing: IconButton(
      tooltip: 'Entfernen',
      icon: const Icon(Icons.delete_outline_rounded),
      onPressed: () => unawaited(ref.read(removeFriendProvider)(f)),
    ),
  );

  static Future<void> _add(
    BuildContext context,
    WidgetRef ref,
    Future<FriendCard?> Function(BuildContext) get,
  ) async {
    final card = await get(context);
    if (!context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    if (card == null) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Das ist kein Wandoo-Code.')),
      );
      return;
    }
    if (card.player == ref.read(myCardProvider)?.player) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Das ist dein eigener Code.')),
      );
      return;
    }
    final known = ref
        .read(friendsProvider)
        .where((f) => f.card.player == card.player)
        .firstOrNull;
    final name = await askFriendName(context, before: known?.name);
    if (name == null) return;
    await ref.read(addFriendProvider)(card, name);
  }
}
