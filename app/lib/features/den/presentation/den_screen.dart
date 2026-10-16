import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/bath/bath.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/den/application/room_providers.dart';
import 'package:wandoo/features/den/domain/den_room.dart';
import 'package:wandoo/features/den/presentation/widgets/den_perks_row.dart';
import 'package:wandoo/features/den/presentation/widgets/den_room_view.dart';
import 'package:wandoo/features/den/presentation/widgets/furniture_sheet.dart';
import 'package:wandoo/features/den/presentation/widgets/hibernation_card.dart';
import 'package:wandoo/features/world/world.dart';

/// Das Zuhause: eine Höhle zum Einrichten. Möbel werden aus Fundstücken
/// gebaut. Ab Level 25 schläft hier auch ein zweites Wesen.
class DenScreen extends ConsumerWidget {
  const DenScreen({super.key});

  static const path = '/hoehle';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(creatureProvider).value;
    final room = ref.watch(roomProvider).value ?? const DenRoom();
    if (active == null) return const Scaffold();
    final name = active.hatched
        ? SpeciesCatalog.byId(active.speciesId).name
        : 'deinem Ei';
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Zuhause von $name'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: DenRoomView(
              room: room,
              creature: active,
              world: ref.watch(worldStateProvider),
              onSpot: (spot) => unawaited(showFurnitureSheet(context, spot)),
            ),
          ),
          _Panel(
            children: [
              DenPerksRow(room: room),
              const BathCard(),
              HibernationCard(active: active),
            ],
          ),
        ],
      ),
    );
  }
}

/// Der Bereich unter der Höhle: Boni, Bad und Winterschlaf.
class _Panel extends StatelessWidget {
  const _Panel({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 12)],
    ),
    child: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
        child: Column(mainAxisSize: MainAxisSize.min, children: children),
      ),
    ),
  );
}
