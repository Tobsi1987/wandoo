import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wandoo/features/achievements/achievements.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/friends/friends.dart';
import 'package:wandoo/features/privacy/privacy.dart';
import 'package:wandoo/features/share/share.dart';
import 'package:wandoo/features/shop/shop.dart';

// Knöpfe, die eine Seite in eine andere führen. Sie hängen hier, damit
// sich die Features nicht gegenseitig kennen müssen.

/// Oben rechts im Album: das Erfolge-Buch.
Widget achievementBookAction() => Builder(
  builder: (context) => TextButton.icon(
    onPressed: () => unawaited(context.push(AchievementBookScreen.path)),
    icon: const Icon(Icons.military_tech_rounded),
    label: const Text('Erfolge'),
  ),
);

/// Oben rechts im Album: Freunde und Bestenliste.
Widget friendsAction() => Builder(
  builder: (context) => IconButton(
    key: const Key('friends-open'),
    onPressed: () => unawaited(context.push(FriendsScreen.path)),
    icon: const Icon(Icons.emoji_events_rounded),
    tooltip: 'Freunde',
  ),
);

/// Oben rechts im Album, im Menü: Laden und Datenschutz.
Widget albumMenu() => Builder(
  builder: (context) => PopupMenuButton<String>(
    key: const Key('album-more'),
    onSelected: (path) => unawaited(context.push(path)),
    itemBuilder: (context) => const [
      PopupMenuItem(
        key: Key('shop-open'),
        value: ShopScreen.path,
        child: ListTile(
          leading: Icon(Icons.storefront_rounded),
          title: Text('Laden'),
        ),
      ),
      PopupMenuItem(
        key: Key('privacy-open'),
        value: PrivacyScreen.path,
        child: ListTile(
          leading: Icon(Icons.shield_outlined),
          title: Text('Datenschutz'),
        ),
      ),
    ],
  ),
);

/// Unten im Tagebuch: das Wesen teilen oder in die Wildnis schicken.
class DiaryFooter extends ConsumerWidget {
  const DiaryFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creature = ref.watch(creatureProvider).value;
    if (creature == null || !creature.hatched) return const SizedBox.shrink();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
        child: Wrap(
          alignment: WrapAlignment.spaceEvenly,
          spacing: 8,
          children: [
            TextButton.icon(
              onPressed: () => unawaited(context.push(ShareScreen.path)),
              icon: const Icon(Icons.share_rounded),
              label: const Text('Teilen'),
            ),
            ReleaseButton(creature: creature),
          ],
        ),
      ),
    );
  }
}
