import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/hunger/application/hunger_providers.dart';

/// Der Hungerbalken unter dem Wesen: ein Apfel und ein Balken, der sich
/// beim Gehen füllt. Ist er leer, steht darunter, was zu tun ist.
class HungerBar extends ConsumerWidget {
  const HungerBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final belly = ref.watch(currentBellyProvider);
    final creature = ref.watch(creatureProvider).value;
    if (belly == null || creature == null) return const SizedBox.shrink();
    final fill = belly.fillAt(ref.watch(hungerClockProvider)());
    final name = SpeciesCatalog.byId(creature.speciesId).name;
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      label: 'Bauch zu ${(fill * 100).round()} Prozent voll',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🍎', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox(
                    width: 104,
                    height: 10,
                    child: LinearProgressIndicator(
                      value: fill,
                      color: _color(fill),
                      backgroundColor: scheme.onSurface.withValues(alpha: 0.15),
                    ),
                  ),
                ),
              ],
            ),
            if (fill <= 0)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '$name hat Hunger! Geht zusammen raus.',
                  style: TextStyle(
                    color: scheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  static Color _color(double fill) => fill > 0.4
      ? const Color(0xFF4CAF50)
      : fill > 0.2
      ? const Color(0xFFFFA726)
      : const Color(0xFFE53935);
}
