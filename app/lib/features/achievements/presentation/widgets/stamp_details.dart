import 'package:flutter/material.dart';
import 'package:wandoo/features/achievements/domain/achievement.dart';
import 'package:wandoo/features/achievements/domain/new_stamps.dart';
import 'package:wandoo/features/achievements/presentation/widgets/stamp_tile.dart';

/// Zeigt zu einem Stempel, was man dafür tut und wie weit man ist.
Future<void> showStampDetails(
  BuildContext context,
  Achievement achievement,
  AchievementInputs inputs,
) => showModalBottomSheet<void>(
  context: context,
  showDragHandle: true,
  builder: (context) {
    final value = achievement.value(inputs);
    final text = Theme.of(context).textTheme;
    final u = achievement.unit;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(achievement.emoji, style: const TextStyle(fontSize: 44)),
            Text(achievement.title, style: text.headlineSmall),
            const SizedBox(height: 4),
            Text('Bisher: $value$u ${achievement.what}'),
            const SizedBox(height: 16),
            for (var i = 0; i < achievement.steps.length; i++)
              _StepRow(
                tier: Tier.values[i + 1],
                label: '${achievement.steps[i]}$u ${achievement.what}',
                done: value >= achievement.steps[i],
              ),
          ],
        ),
      ),
    );
  },
);

class _StepRow extends StatelessWidget {
  const _StepRow({required this.tier, required this.label, required this.done});

  final Tier tier;
  final String label;
  final bool done;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        StampMedal(tier: tier),
        const SizedBox(width: 10),
        SizedBox(width: 56, child: Text(tierName(tier))),
        Expanded(child: Text(label)),
        Icon(
          done ? Icons.check_circle : Icons.radio_button_unchecked,
          color: done ? tierColor(tier) : Theme.of(context).disabledColor,
        ),
      ],
    ),
  );
}
