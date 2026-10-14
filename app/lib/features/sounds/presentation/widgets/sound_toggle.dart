import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/sounds/application/sound_providers.dart';
import 'package:wandoo/ui_kit/bar_button.dart';

/// Schaltet die Töne an oder aus: ein runder Knopf für die Leiste.
class SoundToggle extends ConsumerWidget {
  const SoundToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final muted = ref.watch(soundsMutedProvider).value ?? false;
    return BarButton(
      tooltip: muted ? 'Töne aus' : 'Töne an',
      color: const Color(0xFF5C6B7A),
      icon: muted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
      onTap: () => ref
          .read(soundSettingsRepositoryProvider)
          .setMuted(muted: !muted)
          .ignore(),
    );
  }
}
