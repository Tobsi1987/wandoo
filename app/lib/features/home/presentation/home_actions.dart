import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wandoo/features/adventures/adventures.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/discovery_map/discovery_map.dart';
import 'package:wandoo/features/share/share.dart';
import 'package:wandoo/features/treasure/treasure.dart';

/// Die Knöpfe oben rechts auf dem Startbildschirm.
List<Widget> homeActions(BuildContext context) => [
  _action(
    context,
    'Wochen-Abenteuer',
    Icons.flag_outlined,
    AdventureScreen.path,
  ),
  _action(
    context,
    'Sammelalbum',
    Icons.collections_bookmark_outlined,
    AlbumScreen.path,
  ),
  _action(
    context,
    'Schatzkiste',
    Icons.inventory_2_outlined,
    TreasureScreen.path,
  ),
  _action(context, 'Wesen teilen', Icons.ios_share, ShareScreen.path),
  _action(
    context,
    'Entdeckungskarte',
    Icons.map_outlined,
    DiscoveryMapScreen.path,
  ),
];

Widget _action(BuildContext context, String tip, IconData icon, String path) =>
    IconButton(
      tooltip: tip,
      icon: Icon(icon),
      onPressed: () => context.push(path),
    );
