import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wandoo/features/bath/application/bath_providers.dart';
import 'package:wandoo/features/bath/presentation/bath_screen.dart';

/// Hinweis im Zuhause, sobald das Wesen schmutzig ist: ab in die Wanne.
class BathCard extends ConsumerWidget {
  const BathCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mud = ref.watch(currentMudProvider);
    if (mud == 0) return const SizedBox.shrink();
    const words = ['etwas schmutzig', 'schmutzig', 'ganz matschig'];
    return Card(
      child: ListTile(
        leading: const Text('🛁', style: TextStyle(fontSize: 28)),
        title: Text('Dein Wesen ist ${words[mud - 1]}.'),
        subtitle: const Text('Ab in die Wanne!'),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => unawaited(context.push(BathScreen.path)),
      ),
    );
  }
}
