import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/tracking/application/tracking_providers.dart';
import 'package:wandoo/features/tracking/domain/walk_session.dart';
import 'package:wandoo/features/tracking/presentation/start_button.dart';

/// Knopf zum Starten und Beenden eines Gangs, mit Strecke während des Gangs.
class WalkPanel extends ConsumerWidget {
  const WalkPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(trackingControllerProvider);
    final controller = ref.read(trackingControllerProvider.notifier);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        switch (session) {
          WalkRecording(tooFast: true) => const Text(
            'Ganz schön schnell! Im Auto, Bus oder auf dem Rad zählen '
            'die Wege nicht, nur zu Fuß.',
            textAlign: TextAlign.center,
          ),
          WalkRecording(:final distanceMeters) => Text(
            '${distanceMeters.round()} m unterwegs',
          ),
          WalkIdle(permissionDenied: true) => const Text(
            'Ohne Standortfreigabe kann Wandoo deinen Weg nicht sehen.',
            textAlign: TextAlign.center,
          ),
          WalkIdle() => const SizedBox.shrink(),
        },
        const SizedBox(height: 12),
        if (session is WalkRecording)
          FilledButton.icon(
            onPressed: controller.stop,
            icon: const Icon(Icons.stop),
            label: const Text('Gang beenden'),
          )
        else
          StartButton(onPressed: controller.start),
      ],
    );
  }
}
