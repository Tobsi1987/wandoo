import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/adventures/application/adventure_providers.dart';
import 'package:wandoo/features/adventures/domain/weekly_adventure.dart';
import 'package:wandoo/features/adventures/presentation/widgets/quest_card.dart';

/// Die Abenteuer dieser Woche und das Glücks-Ei für alle drei.
class AdventureScreen extends ConsumerWidget {
  const AdventureScreen({super.key});

  static const path = '/abenteuer';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adventure = ref.watch(weeklyAdventureProvider).value;
    final now = ref.watch(adventureClockProvider)();
    return Scaffold(
      appBar: AppBar(title: const Text('Wochen-Abenteuer')),
      body: adventure == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(_daysLeft(adventure, now)),
                const SizedBox(height: 8),
                for (final q in adventure.quests) QuestCard(quest: q),
                const SizedBox(height: 8),
                _BonusCard(claimed: adventure.bonusClaimed),
              ],
            ),
    );
  }

  static String _daysLeft(WeeklyAdventure a, DateTime now) {
    final end = DateTime(
      a.weekStart.year,
      a.weekStart.month,
      a.weekStart.day + 7,
    );
    final days = end.difference(now).inHours ~/ 24 + 1;
    return days <= 1
        ? 'Heute ist der letzte Tag dieser Woche.'
        : 'Noch $days Tage, dann gibt es neue Abenteuer.';
  }
}

class _BonusCard extends StatelessWidget {
  const _BonusCard({required this.claimed});

  final bool claimed;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: ListTile(
        leading: const Text('🍀', style: TextStyle(fontSize: 28)),
        title: Text(claimed ? 'Glücks-Ei verdient!' : 'Alle drei schaffen'),
        subtitle: Text(
          claimed
              ? 'Dein nächstes Ei bringt mindestens ein seltenes Tier.'
              : 'Dann wird dein nächstes Ei ein Glücks-Ei: Es bringt '
                    'mindestens ein seltenes Tier.',
        ),
      ),
    );
  }
}
