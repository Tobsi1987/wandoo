import 'package:flutter/material.dart';
import 'package:wandoo/features/creature/creature.dart';

/// Das Bild, das geteilt wird: Wesen, Stufe und Merkmale im Hochformat.
class ShareCard extends StatelessWidget {
  const ShareCard({required this.creature, super.key});

  /// Seitenverhältnis 4:5, passt in die gängigen Feeds.
  static const size = Size(360, 450);

  final Creature creature;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return SizedBox.fromSize(
      size: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [colors.primaryContainer, colors.surface],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text('Wandoo', style: text.titleLarge),
              Expanded(
                child: Center(
                  child: CreatureAvatar(creature: creature, figureSize: 150),
                ),
              ),
              Text(
                'Gewachsen auf neuen Wegen',
                style: text.bodySmall?.copyWith(color: colors.outline),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
