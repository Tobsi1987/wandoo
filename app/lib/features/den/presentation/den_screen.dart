import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/den/application/den_providers.dart';
import 'package:wandoo/features/world/world.dart';

/// Die Höhle: Hier hält ein zweites Wesen Winterschlaf. Es braucht weder
/// Gänge noch Futter. Mit einem Tipp wird getauscht.
class DenScreen extends ConsumerWidget {
  const DenScreen({super.key});

  static const path = '/hoehle';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(creatureProvider).value;
    final sleeper = ref.watch(sleeperProvider).value;
    final text = Theme.of(context).textTheme;
    // Im Winterschlaf sind die Augen zu wie nachts.
    final night = WorldState(
      daytime: Daytime.night,
      eggTheme: ref.watch(worldStateProvider).eggTheme,
    );
    if (active == null) return const Scaffold();
    final name = _name(active);
    return Scaffold(
      appBar: AppBar(title: const Text('Die Höhle')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _figure(active, 'Mit dir unterwegs: $name', text),
          const SizedBox(height: 24),
          if (sleeper == null) ...[
            Text(
              '$name ist schon so groß, dass es eine Pause verdient hat. In '
              'der Höhle hält es Winterschlaf, ganz ohne Hunger und ohne '
              'Gänge. Dafür bekommst du ein neues Ei. Tauschen kannst du '
              'jederzeit.',
              style: text.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () =>
                  _do(context, ref.read(swapCreaturesProvider).takeSecondEgg),
              child: Text('🥚 Neues Ei holen, $name schläft'),
            ),
          ] else ...[
            _figure(
              sleeper.creature,
              '💤 Im Winterschlaf: '
              '${_name(sleeper.creature)}',
              text,
              night: night,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () =>
                  _do(context, ref.read(swapCreaturesProvider).swap),
              child: Text(
                '${_name(sleeper.creature)} aufwecken, $name '
                'schläft',
              ),
            ),
          ],
        ],
      ),
    );
  }

  static String _name(Creature c) =>
      c.hatched ? SpeciesCatalog.byId(c.speciesId).name : 'dein Ei';

  static Future<void> _do(
    BuildContext context,
    Future<void> Function() action,
  ) async {
    await action();
    if (context.mounted) Navigator.of(context).maybePop();
  }

  static Widget _figure(
    Creature c,
    String label,
    TextTheme text, {
    WorldState? night,
  }) => Column(
    children: [
      CreatureFigure(
        creature: c,
        size: 150,
        world: night,
        awake: night == null,
      ),
      const SizedBox(height: 8),
      Text(label, style: text.titleMedium, textAlign: TextAlign.center),
    ],
  );
}
