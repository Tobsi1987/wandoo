import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/privacy/application/privacy_providers.dart';

/// Die zwei Schalter für alles, was nicht nötig ist: Wetter und Kartenbild.
class PrivacySwitches extends ConsumerWidget {
  const PrivacySwitches({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final choices = ref.watch(privacyChoicesProvider);
    final update = ref.read(updatePrivacyProvider);
    return Column(
      children: [
        SwitchListTile(
          key: const Key('privacy-weather'),
          value: choices?.weather ?? false,
          onChanged: (on) => update((c) => c.copyWith(weather: on)),
          secondary: const Icon(Icons.cloud_rounded),
          title: const Text('Echtes Wetter'),
          subtitle: const Text(
            'Fragt Open-Meteo nach dem Wetter am groben Ort (auf etwa 10 km).',
          ),
        ),
        SwitchListTile(
          key: const Key('privacy-base-map'),
          value: choices?.baseMap ?? false,
          onChanged: (on) => update((c) => c.copyWith(baseMap: on)),
          secondary: const Icon(Icons.map_rounded),
          title: const Text('Kartenbild'),
          subtitle: const Text(
            'Lädt das Bild der Karte von OpenStreetMap. Ohne es siehst du '
            'nur deine Wege.',
          ),
        ),
      ],
    );
  }
}
