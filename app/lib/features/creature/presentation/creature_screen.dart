import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/creature/application/creature_providers.dart';
import 'package:wandoo/features/creature/presentation/widgets/creature_avatar.dart';

/// Hauptbildschirm: das Wesen.
class CreatureScreen extends ConsumerWidget {
  const CreatureScreen({super.key});

  static const path = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creature = ref.watch(creatureProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Wandoo')),
      body: Center(
        child: creature.when(
          data: (c) => CreatureAvatar(creature: c),
          loading: () => const CircularProgressIndicator(),
          error: (error, _) => Text('Fehler: $error'),
        ),
      ),
    );
  }
}
