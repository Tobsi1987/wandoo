import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/sounds/application/sound_providers.dart';

/// Knopf, um die Laute an- oder auszuschalten.
class SoundToggle extends ConsumerWidget {
  const SoundToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final muted = ref.watch(soundsMutedProvider).value ?? false;
    return TextButton.icon(
      onPressed: () => ref
          .read(soundSettingsRepositoryProvider)
          .setMuted(muted: !muted)
          .ignore(),
      icon: Icon(muted ? Icons.volume_off : Icons.volume_up),
      label: Text(muted ? 'Töne aus' : 'Töne an'),
    );
  }
}
