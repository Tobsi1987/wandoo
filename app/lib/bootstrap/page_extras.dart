import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wandoo/features/achievements/achievements.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/privacy/privacy.dart';
import 'package:wandoo/features/share/share.dart';

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

/// Oben rechts im Album: Datenschutz.
Widget privacyAction() => Builder(
  builder: (context) => IconButton(
    key: const Key('privacy-open'),
    onPressed: () => unawaited(context.push(PrivacyScreen.path)),
    icon: const Icon(Icons.shield_outlined),
    tooltip: 'Datenschutz',
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
