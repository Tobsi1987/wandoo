import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/bootstrap/router.dart';
import 'package:wandoo/features/bath/bath.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/home_widget/home_widget.dart';
import 'package:wandoo/features/hunger/hunger.dart';
import 'package:wandoo/features/levels/levels.dart';
import 'package:wandoo/features/petting/petting.dart';
import 'package:wandoo/features/tracking/tracking.dart';
import 'package:wandoo/flows/creature_reminder/creature_reminder_provider.dart';
import 'package:wandoo/flows/hunger/check_hunger_provider.dart';
import 'package:wandoo/flows/levels/gain_xp_provider.dart';
import 'package:wandoo/flows/process_walk/process_walk_provider.dart';
import 'package:wandoo/flows/scent/sniff_out_provider.dart';
import 'package:wandoo/ui_kit/wandoo_theme.dart';

class WandooApp extends ConsumerWidget {
  const WandooApp({super.key});

  /// Größer wird die Schrift nicht, egal was am Handy eingestellt ist.
  static const maxTextScale = 1.15;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Jeder neu abgelegte Gang (und offene Gänge beim Start) wird verarbeitet.
    ref.listen(pendingWalkCountProvider, (_, count) {
      if ((count.value ?? 0) > 0) {
        ref.read(pendingWalkProcessorProvider).processAll().ignore();
      }
    });
    // Nach jeder Fütterung: Hunger prüfen, Erinnerung neu planen, Widget
    // auffrischen.
    ref
      ..listen(creatureProvider, (_, creature) {
        final value = creature.value;
        if (value == null) return;
        ref.read(checkHungerProvider)().ignore();
        _remind(ref);
        ref.read(syncHomeWidgetProvider)(value).ignore();
      })
      ..listen(currentBellyProvider, (_, _) => _remind(ref))
      // Jeder Freundschaftspunkt (Streicheln) bringt Erfahrung.
      ..listen(friendshipProvider, (before, now) {
        final old = before?.value;
        final f = now.value;
        final creature = ref.read(creatureProvider).value;
        if (old == null || f == null || creature == null) return;
        if (old.creatureKey != f.creatureKey || f.points <= old.points) return;
        ref
            .read(gainXpProvider)(
              creature,
              (f.points - old.points) * Xp.perFriendPoint,
              announce: true,
            )
            .ignore();
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
      // Große Systemschrift nur bis zu einem Maß, sonst passen Wörter
      // nicht mehr in Knöpfe und Kacheln.
      builder: (context, child) => MediaQuery.withClampedTextScaling(
        maxScaleFactor: maxTextScale,
        child: _looks(ref, child!),
      ),
    );
  }

  /// Wie das Wesen überall aussieht: Spuren der Welt und Matsch.
  static Widget _looks(WidgetRef ref, Widget child) => WorldMarksShown(
    shown: ref.watch(marksShownProvider).value ?? true,
    child: CreatureMud(
      creature: ref.watch(creatureProvider).value,
      level: ref.watch(currentMudProvider),
      child: child,
    ),
  );

  /// Plant die Erinnerungen, dringlicher, sobald der Bauch leer ist.
  static void _remind(WidgetRef ref) {
    final creature = ref.read(creatureProvider).value;
    if (creature == null) return;
    final hungryAt = ref.read(currentBellyProvider)?.emptyAt;
    ref
        .read(syncCreatureReminderProvider)(creature, hungryAt: hungryAt)
        .ignore();
  }
}
