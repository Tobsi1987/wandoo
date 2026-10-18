import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/home/presentation/home_actions.dart';
import 'package:wandoo/features/hunger/hunger.dart';
import 'package:wandoo/features/levels/levels.dart';
import 'package:wandoo/features/petting/petting.dart';
import 'package:wandoo/features/scent/scent.dart';
import 'package:wandoo/features/sounds/sounds.dart';
import 'package:wandoo/features/star_catch/star_catch.dart';
import 'package:wandoo/features/tracking/tracking.dart';
import 'package:wandoo/features/walk_summary/walk_summary.dart';
import 'package:wandoo/features/world/world.dart';
import 'package:wandoo/ui_kit/wandoo_theme.dart';

/// Startbildschirm: das Wesen mitten in seiner Welt, unten der Knopf für
/// den nächsten Gang; nach einem Gang in der Mitte, was er gebracht hat.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const path = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final world = ref.watch(worldStateProvider);
    final walking = ref.watch(trackingControllerProvider) is WalkRecording;
    final summary = ref.watch(latestUnseenSummaryProvider).value;
    final showSummary = summary != null && !walking;
    final processing = (ref.watch(pendingWalkCountProvider).value ?? 0) > 0;
    final starving = ref.watch(starvingProvider);
    // Der Himmel ist tagsüber hell, nachts dunkel; die Schrift folgt ihm.
    return Theme(
      data: world.night ? WandooTheme.dark() : WandooTheme.light(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 12,
          toolbarHeight: 64,
          // Während der Zusammenfassung nur Wesen und Karte, sonst nichts.
          title: showSummary ? null : const HomeTopBar(),
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            WorldBackdrop(world: world, groundAt: 0.52),
            // Schlüpfen und Freude warten, bis die Zusammenfassung zu ist.
            CelebrationStage(
              hold: processing || showSummary,
              onPlay: (moment, c) => _cheer(ref, moment, c),
              child: _main(
                world,
                walking: walking,
                sleepy: starving,
                calm: showSummary,
              ),
            ),
            if (showSummary) ..._summary(),
          ],
        ),
      ),
    );
  }

  /// Wesen in der Mitte, unten der Knopf für den nächsten Gang.
  static Widget _main(
    WorldState world, {
    required bool walking,
    required bool sleepy,
    bool calm = false,
  }) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: LayoutBuilder(
        builder: (context, box) => Column(
          children: [
            Expanded(
              child: _creature(
                world,
                walking: walking,
                sleepy: sleepy,
                calm: calm,
                box: box,
              ),
            ),
            // Während der Zusammenfassung unsichtbar, der Platz bleibt.
            AnimatedOpacity(
              opacity: calm ? 0 : 1,
              duration: const Duration(milliseconds: 200),
              child: IgnorePointer(
                ignoring: calm,
                child: const Column(
                  children: [
                    LevelUpBanner(),
                    FarewellLetter(),
                    SniffBubble(),
                    WalkPanel(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  /// Nach einem Gang: Das Wesen bleibt oben zu sehen, die Zusammenfassung
  /// liegt unten, wo sonst Schild und Losgehen-Knopf sind.
  static List<Widget> _summary() => const [
    ModalBarrier(color: Colors.black26),
    SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: WalkSummaryCard(lastPageExtra: StarCatchButton()),
        ),
      ),
    ),
  ];

  /// Ton zum Moment: Jubel beim Schlüpfen, Freude übers Futter. Kurz
  /// warten, bis die Figur wirklich springt.
  static void _cheer(WidgetRef ref, CelebrationMoment moment, Creature c) {
    final hatch =
        moment == CelebrationMoment.hatch || moment == CelebrationMoment.evolve;
    Future<void>.delayed(
      Duration(milliseconds: hatch ? 1600 : 600),
      () => ref.read(playSoundProvider)(
        hatch ? Cue.cheer : Cue.happy,
        speciesId: c.speciesId,
      ),
    ).ignore();
  }

  /// Das Wesen zum Streicheln, mit Herzen und Tagebuch.
  static Widget _creature(
    WorldState world, {
    required bool walking,
    required bool sleepy,
    required bool calm,
    required BoxConstraints box,
  }) => CreatureCard(
    walking: walking,
    plateShown: !calm,
    figureSize: _figureSize(box),
    figureWrap: (figure) =>
        Pettable(asleep: (world.night || sleepy) && !walking, child: figure),
    below: const [
      Wrap(
        spacing: 14,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        children: [HeartsBar(), HungerBar(), LevelBar()],
      ),
    ],
    release: false,
    fill: true,
  );

  static double _figureSize(BoxConstraints box) =>
      math.min(box.maxWidth * 1.05, box.maxHeight * 0.62);
}
