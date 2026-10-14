import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wandoo/features/achievements/achievements.dart';
import 'package:wandoo/features/adventures/adventures.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/den/den.dart';
import 'package:wandoo/features/diary/diary.dart';
import 'package:wandoo/features/discovery_map/discovery_map.dart';
import 'package:wandoo/features/share/share.dart';
import 'package:wandoo/features/sounds/sounds.dart';
import 'package:wandoo/features/treasure/treasure.dart';

/// Links oben: der Lautsprecher, auf einem hellen Kreis.
Widget homeLeading() => const Padding(
  padding: EdgeInsets.only(left: 8),
  child: _Frosted(child: SoundToggle()),
);

/// Rechts oben: eine helle Leiste mit den Orten der App, dazu "Mehr".
List<Widget> homeActions(BuildContext context) => [
  _Frosted(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _action(
          context,
          'Wochen-Abenteuer',
          'adventures',
          AdventureScreen.path,
        ),
        _action(context, 'Sammelalbum', 'album', AlbumScreen.path),
        const DiaryButton(),
        _action(context, 'Schatzkiste', 'treasure', TreasureScreen.path),
        _action(context, 'Entdeckungskarte', 'map', DiscoveryMapScreen.path),
        IconButton(
          tooltip: 'Mehr',
          icon: const Icon(Icons.more_horiz_rounded),
          onPressed: () => unawaited(_more(context)),
        ),
      ],
    ),
  ),
  const SizedBox(width: 8),
];

/// Gemalte Icons aus `assets/ui/` (Midjourney).
Widget _action(BuildContext context, String tip, String icon, String path) =>
    IconButton(
      tooltip: tip,
      padding: const EdgeInsets.all(4),
      icon: Image.asset('assets/ui/$icon.png', width: 32, height: 32),
      onPressed: () => context.push(path),
    );

/// Was seltener gebraucht wird: Erfolge-Buch, teilen, Höhle, wegschicken.
Future<void> _more(BuildContext context) => showModalBottomSheet<void>(
  context: context,
  showDragHandle: true,
  builder: (sheet) => SafeArea(
    child: Consumer(
      builder: (context, ref, _) {
        final creature = ref.watch(creatureProvider).value;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton.icon(
              onPressed: () {
                Navigator.pop(sheet);
                unawaited(context.push(AchievementBookScreen.path));
              },
              icon: const Text('📖', style: TextStyle(fontSize: 24)),
              label: const Text('Erfolge-Buch'),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.pop(sheet);
                unawaited(context.push(ShareScreen.path));
              },
              icon: Image.asset('assets/ui/share.png', width: 28, height: 28),
              label: const Text('Wesen teilen'),
            ),
            const DenButton(),
            if (creature != null) ReleaseButton(creature: creature),
            const SizedBox(height: 8),
          ],
        );
      },
    ),
  ),
);

/// Heller, runder Hintergrund, damit die Knöpfe auf jedem Himmel gleich
/// ruhig aussehen.
class _Frosted extends StatelessWidget {
  const _Frosted({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.7),
      borderRadius: BorderRadius.circular(28),
    ),
    child: Padding(padding: const EdgeInsets.all(2), child: child),
  );
}
