import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/levels/application/level_providers.dart';

/// Zeigt Level-Aufstiege, die nicht nach einem Gang kamen (zum Beispiel
/// beim Streicheln), bis man sie wegtippt.
class LevelUpBanner extends ConsumerWidget {
  const LevelUpBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);
    if (progress == null || progress.news.isEmpty) {
      return const SizedBox.shrink();
    }
    final text = Theme.of(context).textTheme;
    return Semantics(
      container: true,
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 12, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final line in progress.news)
                Text(
                  line,
                  style: text.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              TextButton(
                onPressed: () => ref
                    .read(progressRepositoryProvider)
                    .save(progress.copyWith(news: const [])),
                child: const Text('Juhu!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
