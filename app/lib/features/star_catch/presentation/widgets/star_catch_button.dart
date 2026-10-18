import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wandoo/features/star_catch/application/star_catch_providers.dart';
import 'package:wandoo/features/star_catch/presentation/star_catch_screen.dart';

/// Nach einem Gang: einmal Sternschnuppen fangen.
class StarCatchButton extends ConsumerWidget {
  const StarCatchButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(starCatchWalkProvider) == null) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      width: double.infinity,
      child: FilledButton.tonal(
        onPressed: () => context.push(StarCatchScreen.path),
        child: const Text('🌠 Sternschnuppen fangen'),
      ),
    );
  }
}
