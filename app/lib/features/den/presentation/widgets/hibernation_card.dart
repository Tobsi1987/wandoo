import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/den/application/den_providers.dart';
import 'package:wandoo/features/world/world.dart';

/// Die Winterschlaf-Ecke: ab Level 25 schläft hier ein zweites Wesen.
/// Vorher steht nur da, was es einmal geben wird.
class HibernationCard extends ConsumerWidget {
  const HibernationCard({required this.active, super.key});

  final Creature active;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    if (!ref.watch(denUnlockedProvider)) {
      return Card(
        child: ListTile(
          leading: const Icon(Icons.lock_rounded),
          title: const Text('Winterschlaf-Ecke'),
          subtitle: Text(
            'Ab Level 25 kann ${_name(active)} hier Winterschlaf halten, '
            'und du bekommst ein zweites Ei.',
          ),
        ),
      );
    }
    final sleeper = ref.watch(sleeperProvider).value;
    final name = _name(active);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: sleeper == null
            ? Column(
                children: [
                  Text(
                    '$name ist schon so groß, dass es eine Pause verdient '
                    'hat. Im Winterschlaf braucht es weder Futter noch '
                    'Gänge, und du bekommst ein neues Ei. Tauschen kannst '
                    'du jederzeit.',
                    style: text.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () =>
                        ref.read(swapCreaturesProvider).takeSecondEgg(),
                    child: Text('🥚 Neues Ei holen, $name schläft'),
                  ),
                ],
              )
            : _sleeping(ref, sleeper.creature, name, text),
      ),
    );
  }

  Widget _sleeping(WidgetRef ref, Creature c, String name, TextTheme text) {
    final night = WorldState(
      daytime: Daytime.night,
      eggTheme: ref.watch(worldStateProvider).eggTheme,
    );
    return Column(
      children: [
        CreatureFigure(creature: c, size: 120, world: night),
        Text('💤 Im Winterschlaf: ${_name(c)}', style: text.titleMedium),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: () => ref.read(swapCreaturesProvider).swap(),
          child: Text('${_name(c)} aufwecken, $name schläft'),
        ),
      ],
    );
  }

  static String _name(Creature c) =>
      c.hatched ? SpeciesCatalog.byId(c.speciesId).name : 'dein Ei';
}
