import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/hunger/application/hunger_providers.dart';

/// Der Brief eines Wesens, das vor Hunger ausgezogen ist. Liegt über dem
/// neuen Ei, bis er gelesen ist.
class FarewellLetter extends ConsumerWidget {
  const FarewellLetter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final letter = ref.watch(farewellProvider).value;
    if (letter == null) return const SizedBox.shrink();
    final name = SpeciesCatalog.byId(letter.speciesId).name;
    final text = Theme.of(context).textTheme;
    return Semantics(
      container: true,
      label: 'Ein Brief von $name',
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '💌 Ein Brief von $name',
                style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(farewellText(name), style: text.bodyMedium),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: () =>
                      ref.read(bellyRepositoryProvider).leaveLetter(null),
                  child: const Text('Zum neuen Ei'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Was im Brief steht: traurig, aber ohne Schuld, und mit Trost.
String farewellText(String name) =>
    'Ich hatte so lange nichts zu essen, dass ich mir selbst Futter suchen '
    'musste. Jetzt wohne ich draußen bei den Beeren. Danke für unsere '
    'Spaziergänge, ich vergesse dich nie! Ich habe dir ein Ei dagelassen. '
    'Geh oft mit ihm raus, dann wird es ganz stark.\n\nDein $name';
