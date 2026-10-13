import 'package:flutter/material.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/tracking/tracking.dart';

/// Startbildschirm: das Wesen und der Knopf für den nächsten Gang.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const path = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wandoo')),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(child: Center(child: CreatureCard())),
              WalkPanel(),
            ],
          ),
        ),
      ),
    );
  }
}
