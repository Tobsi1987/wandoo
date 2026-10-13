import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wandoo/features/adventures/adventures.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/discovery_map/discovery_map.dart';
import 'package:wandoo/features/share/share.dart';
import 'package:wandoo/features/treasure/treasure.dart';

/// Die Knöpfe oben rechts auf dem Startbildschirm.
List<Widget> homeActions(BuildContext context) => [
  _action(context, 'Wochen-Abenteuer', 'adventures', AdventureScreen.path),
  _action(context, 'Sammelalbum', 'album', AlbumScreen.path),
  _action(context, 'Schatzkiste', 'treasure', TreasureScreen.path),
  _action(context, 'Wesen teilen', 'share', ShareScreen.path),
  _action(context, 'Entdeckungskarte', 'map', DiscoveryMapScreen.path),
];

/// Gemalte Icons aus `assets/ui/` (Midjourney).
Widget _action(BuildContext context, String tip, String icon, String path) =>
    IconButton(
      tooltip: tip,
      padding: const EdgeInsets.all(4),
      icon: Image.asset('assets/ui/$icon.png', width: 36, height: 36),
      onPressed: () => context.push(path),
    );
