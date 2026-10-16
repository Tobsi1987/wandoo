import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:wandoo/core/format/distance_label.dart';
import 'package:wandoo/features/creature/domain/creature.dart';
import 'package:wandoo/features/creature/domain/species_catalog.dart';
import 'package:wandoo/features/creature/presentation/celebration/creature_celebration.dart';
import 'package:wandoo/features/creature/presentation/celebration/evolution_moment.dart';
import 'package:wandoo/features/creature/presentation/creature_labels.dart';
import 'package:wandoo/features/creature/presentation/widgets/creature_figure.dart';
import 'package:wandoo/features/creature/presentation/widgets/trait_badge.dart';
import 'package:wandoo/features/world/world.dart';

/// Zeigt das Wesen als Figur, dazu Stufe, Futter und Merkmale.
class CreatureAvatar extends StatelessWidget {
  const CreatureAvatar({
    required this.creature,
    this.figureSize = 180,
    this.world,
    this.inScene = false,
    this.walking = false,
    this.footer = const [],
    this.figureWrap,
    this.fill = false,
    super.key,
  });

  final Creature creature;

  /// Nacht und Jahreszeit für die Figur.
  final WorldState? world;

  /// Kantenlänge der gezeichneten Figur.
  final double figureSize;

  /// Steht schon in der Welt (Startseite): kein eigenes Himmelsfenster.
  final bool inScene;

  /// Während eines Gangs: wach und hüpft vor Freude.
  final bool walking;

  /// Steht mit auf dem hellen Schild unter der Figur.
  final List<Widget> footer;

  /// Legt etwas um die Figur, zum Beispiel Streicheln.
  final Widget Function(Widget figure)? figureWrap;

  /// Füllt die ganze Höhe: Die Figur nimmt, was das Schild übrig lässt,
  /// höchstens [figureSize]. So passt alles ohne Scrollen auf eine Seite.
  final bool fill;

  String get _title => creature.hatched
      ? SpeciesCatalog.byId(creature.speciesId).name
      : stageLabel(creature.stage);

  Widget _figure(double size) {
    final figure = CreatureCelebration(
      creature: creature,
      size: size,
      cheer: walking,
      builder: (c) => EvolutionMoment(
        creature: c,
        size: size,
        child: CreatureFigure(
          creature: c,
          size: size,
          world: world,
          awake: walking,
        ),
      ),
    );
    final wrapped = figureWrap?.call(figure) ?? figure;
    final w = world;
    return w == null || inScene ? wrapped : SkyBox(world: w, child: wrapped);
  }

  String get _subtitle {
    final walked = '👣 ${distanceLabel(creature.walkedMeters)}';
    if (!creature.hatched) return '$walked zusammen gelaufen';
    final rarity = SpeciesCatalog.byId(creature.speciesId).rarity;
    return '${stageLabel(creature.stage)} · ${rarityLabel(rarity)} · $walked';
  }

  @override
  Widget build(BuildContext context) {
    final plate = _plate(context, [..._info(context), ...footer]);
    if (fill) {
      return Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              // Unten, damit das Wesen auf der Wiese steht.
              builder: (context, box) => Align(
                alignment: Alignment.bottomCenter,
                child: _labelled(_figure(math.min(figureSize, box.maxHeight))),
              ),
            ),
          ),
          plate,
        ],
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _labelled(_figure(figureSize)),
        const SizedBox(height: 8),
        plate,
      ],
    );
  }

  Widget _labelled(Widget figure) =>
      Semantics(label: 'Dein Wesen: $_title', child: figure);

  /// In der Welt steht der Text auf einem hellen Schild, damit er auf
  /// gemalten Hintergründen lesbar bleibt.
  Widget _plate(BuildContext context, List<Widget> children) {
    final column = Column(mainAxisSize: MainAxisSize.min, children: children);
    if (!inScene) return column;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 6, 14, 8),
        child: column,
      ),
    );
  }

  List<Widget> _info(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return [
      Text(
        _title,
        style: (inScene ? text.titleLarge : text.headlineMedium)?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      Text(_subtitle, style: text.bodySmall, textAlign: TextAlign.center),
      SizedBox(height: inScene ? 2 : 8),
      Wrap(
        spacing: 6,
        runSpacing: 6,
        alignment: WrapAlignment.center,
        children: [
          for (final entry in creature.traitPoints.entries)
            TraitBadge(trait: entry.key, points: entry.value),
        ],
      ),
    ];
  }
}
