import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wandoo/features/den/application/den_providers.dart';
import 'package:wandoo/features/den/presentation/den_screen.dart';

/// Führt in die Höhle, sobald es sie gibt.
class DenButton extends ConsumerWidget {
  const DenButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(denUnlockedProvider)) return const SizedBox.shrink();
    return TextButton.icon(
      onPressed: () => context.push(DenScreen.path),
      icon: const Icon(Icons.bedtime_outlined),
      label: const Text('Höhle'),
    );
  }
}
