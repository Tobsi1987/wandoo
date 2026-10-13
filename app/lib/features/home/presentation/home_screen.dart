import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/discovery_map/discovery_map.dart';
import 'package:wandoo/features/tracking/tracking.dart';
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
