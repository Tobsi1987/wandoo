import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/levels/application/level_providers.dart';
import 'package:wandoo/features/levels/domain/level_curve.dart';

/// Das Level des Wesens mit einem dünnen Balken bis zum nächsten.
class LevelBar extends ConsumerWidget {
  const LevelBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);
    if (progress == null) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;
    final max = progress.level == LevelCurve.maxLevel;
    return Semantics(
      label: max
          ? 'Level ${progress.level}, höchstes Level'
          : 'Level ${progress.level}, '
                '${(progress.towardNext * 100).round()} Prozent zum nächsten',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: scheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Text(
                  'Lv ${progress.level}',
                  style: TextStyle(
                    color: scheme.onPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                width: 104,
                height: 8,
                child: LinearProgressIndicator(
                  value: progress.towardNext,
                  color: const Color(0xFFFFC107),
                  backgroundColor: scheme.onSurface.withValues(alpha: 0.15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
