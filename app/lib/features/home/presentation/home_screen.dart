import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/discovery_map/discovery_map.dart';
import 'package:wandoo/features/share/share.dart';
import 'package:wandoo/features/tracking/tracking.dart';
import 'package:wandoo/features/treasure/treasure.dart';
import 'package:wandoo/features/walk_summary/walk_summary.dart';

/// Startbildschirm: das Wesen und der Knopf für den nächsten Gang.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const path = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wandoo'),
        actions: [
          IconButton(
            tooltip: 'Sammelalbum',
            icon: const Icon(Icons.collections_bookmark_outlined),
            onPressed: () => context.push(AlbumScreen.path),
          ),
          IconButton(
            tooltip: 'Schatzkiste',
            icon: const Icon(Icons.inventory_2_outlined),
            onPressed: () => context.push(TreasureScreen.path),
          ),
          IconButton(
            tooltip: 'Wesen teilen',
            icon: const Icon(Icons.ios_share),
            onPressed: () => context.push(ShareScreen.path),
          ),
          IconButton(
            tooltip: 'Entdeckungskarte',
            icon: const Icon(Icons.map_outlined),
            onPressed: () => context.push(DiscoveryMapScreen.path),
          ),
        ],
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(child: Center(child: CreatureCard())),
              WalkSummaryCard(),
              SizedBox(height: 16),
              WalkPanel(),
            ],
          ),
        ),
      ),
    );
  }
}
