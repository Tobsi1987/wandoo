import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/bootstrap/router.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/home_widget/home_widget.dart';
import 'package:wandoo/features/tracking/tracking.dart';
import 'package:wandoo/flows/creature_reminder/creature_reminder_provider.dart';
import 'package:wandoo/flows/process_walk/process_walk_provider.dart';
import 'package:wandoo/flows/scent/sniff_out_provider.dart';
import 'package:wandoo/ui_kit/wandoo_theme.dart';

class WandooApp extends ConsumerWidget {
  const WandooApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Jeder neu abgelegte Gang (und offene Gänge beim Start) wird verarbeitet.
    ref.listen(pendingWalkCountProvider, (_, count) {
      if ((count.value ?? 0) > 0) {
        ref.read(pendingWalkProcessorProvider).processAll().ignore();
      }
    });
    // Nach jeder Fütterung: Erinnerung neu planen, Widget auffrischen.
    ref.listen(creatureProvider, (_, creature) {
      final value = creature.value;
      if (value == null) return;
      ref.read(syncCreatureReminderProvider)(value).ignore();
      ref.read(syncHomeWidgetProvider)(value).ignore();
    });
    // Beim ersten Standort eines Gangs schnüffelt ein geschlüpftes Wesen.
    ref.listen(trackingControllerProvider, (before, now) {
      final here = now is WalkRecording ? now.position : null;
      final had = before is WalkRecording ? before.position : null;
      final hatched = ref.read(creatureProvider).value?.hatched ?? false;
      if (here == null || had != null || !hatched) return;
      ref.read(sniffOutProvider)(here, DateTime.now()).ignore();
    });
    return MaterialApp.router(
      title: 'Wandoo',
      theme: WandooTheme.light(),
      darkTheme: WandooTheme.dark(),
      routerConfig: appRouter,
    );
  }
}
