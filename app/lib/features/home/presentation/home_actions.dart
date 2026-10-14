import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wandoo/features/adventures/adventures.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/den/den.dart';
import 'package:wandoo/features/diary/diary.dart';
import 'package:wandoo/features/discovery_map/discovery_map.dart';
import 'package:wandoo/features/sounds/sounds.dart';
import 'package:wandoo/features/treasure/treasure.dart';
import 'package:wandoo/ui_kit/bar_button.dart';

/// Die obere Leiste: sieben gleiche runde Knöpfe, gleichmäßig verteilt.
/// Seltenes steckt in den Seiten selbst: das Erfolge-Buch im Album,
/// Teilen und Wegschicken im Tagebuch.
class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.55),
      borderRadius: BorderRadius.circular(32),
    ),
    child: Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SoundToggle(),
          _go(
            context,
            'Zuhause',
            Icons.cottage_rounded,
            0xFFB5651D,
            DenScreen.path,
          ),
          _go(
            context,
            'Wochen-Abenteuer',
            Icons.flag_rounded,
            0xFFD9534F,
            AdventureScreen.path,
          ),
          _go(
            context,
            'Entdeckungskarte',
            Icons.map_rounded,
            0xFF2E8B57,
            DiscoveryMapScreen.path,
          ),
          _go(
            context,
            'Schatzkiste',
            Icons.diamond_rounded,
            0xFF7B5CC4,
            TreasureScreen.path,
          ),
          _go(
            context,
            'Sammelalbum',
            Icons.collections_bookmark_rounded,
            0xFF2F7FC1,
            AlbumScreen.path,
          ),
          _go(
            context,
            'Tagebuch',
            Icons.auto_stories_rounded,
            0xFF9A6B3F,
            DiaryScreen.path,
          ),
        ],
      ),
    ),
  );

  static Widget _go(
    BuildContext context,
    String tip,
    IconData icon,
    int color,
    String path,
  ) => BarButton(
    tooltip: tip,
    icon: icon,
    color: Color(color),
    onTap: () => unawaited(context.push(path)),
  );
}
