import 'package:flutter/material.dart';
import 'package:wandoo/features/adventures/domain/quest.dart';
import 'package:wandoo/features/adventures/presentation/adventure_labels.dart';

/// Ein Abenteuer mit Fortschrittsbalken und Belohnung.
class QuestCard extends StatelessWidget {
  const QuestCard({required this.quest, super.key});

  final Quest quest;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  quest.done ? Icons.check_circle : Icons.flag_outlined,
                  color: quest.done ? scheme.primary : null,
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(questLabel(quest))),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: quest.fraction,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Text(
              '${quest.progress} von ${quest.goal} · '
              'Belohnung: ${rewardLabel(quest)}',
            ),
          ],
        ),
      ),
    );
  }
}
