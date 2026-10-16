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
          title: const HomeTopBar(),
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
              child: _main(world, walking: walking, sleepy: starving),
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
                box: box,
              ),
            ),
            const LevelUpBanner(),
            const FarewellLetter(),
            const SniffBubble(),
            const WalkPanel(),
          ],
        ),
      ),
    ),
  );

  /// Nach einem Gang: abgedunkelt, die Zusammenfassung in der Mitte.
  static List<Widget> _summary() => const [
    ModalBarrier(color: Colors.black38),
    SafeArea(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              WalkSummaryCard(),
              SizedBox(height: 12),
              StarCatchButton(),
            ],
          ),
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
    required BoxConstraints box,
  }) => CreatureCard(
    walking: walking,
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
