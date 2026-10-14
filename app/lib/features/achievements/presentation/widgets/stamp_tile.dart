import 'package:flutter/material.dart';
import 'package:wandoo/features/achievements/domain/achievement.dart';
import 'package:wandoo/features/achievements/domain/new_stamps.dart';
import 'package:wandoo/features/achievements/presentation/widgets/stamp_details.dart';

/// Farbe eines Stempels je Stufe.
Color tierColor(Tier tier) => switch (tier) {
  Tier.none => const Color(0xFFB9B9B0),
  Tier.bronze => const Color(0xFFC07B45),
  Tier.silver => const Color(0xFF9AA6B2),
  Tier.gold => const Color(0xFFE0A920),
};

/// Ein Stempel im Buch: rund, mit Rand in der Farbe der Stufe. Noch nicht
/// erreichte Stempel sind blass. Antippen zeigt, was fehlt.
class StampTile extends StatelessWidget {
  const StampTile({required this.achievement, required this.inputs, super.key});

  final Achievement achievement;
  final AchievementInputs inputs;

  @override
  Widget build(BuildContext context) {
    final tier = achievement.tierFor(inputs);
    final text = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      label: '${achievement.title}, ${tierName(tier)}',
      excludeSemantics: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => showStampDetails(context, achievement, inputs),
        child: Column(
          children: [
            const SizedBox(height: 6),
            _Stamp(emoji: achievement.emoji, tier: tier),
            const SizedBox(height: 6),
            Text(
              achievement.title,
              style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
            Text(
              tierName(tier),
              style: text.bodySmall?.copyWith(color: tierColor(tier)),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stamp extends StatelessWidget {
  const _Stamp({required this.emoji, required this.tier});

  final String emoji;
  final Tier tier;

  @override
  Widget build(BuildContext context) {
    final reached = tier != Tier.none;
    final color = tierColor(tier);
    return Container(
      width: 72,
      height: 72,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: reached
            ? color.withValues(alpha: 0.16)
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border.all(color: color, width: reached ? 4 : 2),
      ),
      child: Opacity(
        opacity: reached ? 1 : 0.3,
        child: Text(emoji, style: const TextStyle(fontSize: 32)),
      ),
    );
  }
}

/// Eine kleine Medaille in der Farbe der Stufe.
class StampMedal extends StatelessWidget {
  const StampMedal({required this.tier, this.size = 18, super.key});

  final Tier tier;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: tierColor(tier),
      border: Border.all(color: Colors.white, width: 2),
    ),
  );
}
