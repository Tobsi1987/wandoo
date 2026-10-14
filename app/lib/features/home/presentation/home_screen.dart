import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/diary/diary.dart';
import 'package:wandoo/features/home/presentation/home_actions.dart';
import 'package:wandoo/features/hunger/hunger.dart';
import 'package:wandoo/features/petting/petting.dart';
import 'package:wandoo/features/scent/scent.dart';
import 'package:wandoo/features/sounds/sounds.dart';
import 'package:wandoo/features/star_catch/star_catch.dart';
import 'package:wandoo/features/tracking/tracking.dart';
import 'package:wandoo/features/walk_summary/walk_summary.dart';
import 'package:wandoo/features/world/world.dart';
import 'package:wandoo/ui_kit/wandoo_theme.dart';

/// Startbildschirm: das Wesen mitten in seiner Welt, unten der Knopf für
/// den nächsten Gang oder, direkt nach einem Gang, was er gebracht hat.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const path = '/';

  /// Wo die Wiese beginnt, als Anteil der Bildschirmhöhe: unter den
  /// Füßen des Wesens, das nach einem Gang höher steht.
  static double _ground(bool summary) => summary ? 0.4 : 0.52;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final world = ref.watch(worldStateProvider);
    final walking = ref.watch(trackingControllerProvider) is WalkRecording;
    final summary = ref.watch(latestUnseenSummaryProvider).value;
    final showSummary = summary != null && !walking;
    final starving = ref.watch(starvingProvider);
    _listenForCheers(ref);
    // Der Himmel ist tagsüber hell, nachts dunkel; die Schrift folgt ihm.
    return Theme(
      data: world.night ? WandooTheme.dark() : WandooTheme.light(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('Wandoo'),
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          actions: homeActions(context),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(end: _ground(showSummary)),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              builder: (context, ground, _) =>
                  WorldBackdrop(world: world, groundAt: ground),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: LayoutBuilder(
                  builder: (context, box) => Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: SingleChildScrollView(
                            child: _creature(
                              world,
                              walking: walking,
                              summary: showSummary,
                              sleepy: starving,
                              box: box,
                            ),
                          ),
                        ),
                      ),
                      ..._bottom(summary: showSummary),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Unten: nach einem Gang die Zusammenfassung, sonst der Knopf zum Gehen.
  static List<Widget> _bottom({required bool summary}) => summary
      ? const [StarCatchButton(), WalkSummaryCard()]
      : const [FarewellLetter(), SniffBubble(), WalkPanel()];

  /// Das Wesen jubelt beim Schlüpfen und freut sich übers Futter.
  static void _listenForCheers(WidgetRef ref) {
    ref.listen(creatureProvider, (before, now) {
      final old = before?.value;
      final c = now.value;
      if (old == null || c == null || !c.hatched) return;
      final cue = old.hatched
          ? (c.food > old.food ? Cue.happy : null)
          : Cue.cheer;
      if (cue == null) return;
      // Kurz warten, bis die Figur wirklich springt.
      Future<void>.delayed(
        Duration(milliseconds: cue == Cue.cheer ? 1600 : 600),
        () => ref.read(playSoundProvider)(cue, speciesId: c.speciesId),
      ).ignore();
    });
  }

  /// Das Wesen zum Streicheln, mit Herzen und Tagebuch.
  static Widget _creature(
    WorldState world, {
    required bool walking,
    required bool summary,
    required bool sleepy,
    required BoxConstraints box,
  }) => CreatureCard(
    walking: walking,
    details: !summary,
    figureSize: _figureSize(box, summary),
    figureWrap: (figure) =>
        Pettable(asleep: (world.night || sleepy) && !walking, child: figure),
    below: const [HeartsBar(), HungerBar()],
    actions: const [DiaryButton(), SoundToggle()],
  );

  static double _figureSize(BoxConstraints box, bool small) {
    final size = math.min(box.maxWidth * 0.7, box.maxHeight * 0.38);
    return small ? size * 0.75 : size;
  }
}
