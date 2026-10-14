import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/creature/application/creature_providers.dart';
import 'package:wandoo/features/creature/domain/trait.dart';
import 'package:wandoo/features/creature/domain/world_mark.dart';

/// Schalter: Spuren der Welt zeigen oder das Wesen normal aussehen lassen.
/// Nur da, wenn das Wesen schon eine Spur hat.
class WorldMarksSwitch extends ConsumerWidget {
  const WorldMarksSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creature = ref.watch(creatureProvider).value;
    final mark = creature == null ? null : WorldMark.of(creature);
    if (mark == null) return const SizedBox.shrink();
    return SwitchListTile(
      key: const Key('world-marks'),
      title: const Text('Spuren vom Weg zeigen'),
      subtitle: Text(markName(mark.trait)),
      value: ref.watch(marksShownProvider).value ?? true,
      onChanged: (shown) => unawaited(
        ref.read(marksSettingRepositoryProvider).setShown(shown: shown),
      ),
    );
  }
}

/// Was die Umgebung am Wesen hinterlässt, in Kinderworten.
String markName(Trait trait) => switch (trait) {
  Trait.moss => 'Moos aus dem Wald',
  Trait.fins => 'Schuppen und Seerose vom Wasser',
  Trait.wheatEars => 'Blumen vom Feld',
  Trait.lanterns => 'Lichter aus der Stadt',
};
