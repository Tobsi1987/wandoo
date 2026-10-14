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

/// Oben rechts im Album: Erfolge-Buch, Freunde, Laden und Datenschutz,
/// als gleiche runde Knöpfe ohne Menü.
List<Widget> albumActions() => [
  _open(
    'achievements-open',
    Icons.military_tech_rounded,
    'Erfolge',
    AchievementBookScreen.path,
  ),
  _open(
    'friends-open',
    Icons.emoji_events_rounded,
    'Freunde',
    FriendsScreen.path,
  ),
  _open('shop-open', Icons.storefront_rounded, 'Laden', ShopScreen.path),
  _open(
    'privacy-open',
    Icons.shield_outlined,
    'Datenschutz',
    PrivacyScreen.path,
  ),
];

Widget _open(String key, IconData icon, String tip, String path) => Builder(
  builder: (context) => IconButton(
    key: Key(key),
    onPressed: () => unawaited(context.push(path)),
    icon: Icon(icon),
    tooltip: tip,
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
