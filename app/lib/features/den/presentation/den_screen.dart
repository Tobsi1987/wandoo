import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/den/application/room_providers.dart';
import 'package:wandoo/features/den/domain/den_room.dart';
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
      appBar: AppBar(title: Text('Zuhause von $name')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DenRoomView(
            room: room,
            creature: active,
            world: ref.watch(worldStateProvider),
            onSpot: (spot) => unawaited(showFurnitureSheet(context, spot)),
          ),
          const SizedBox(height: 8),
          Text(
            'Tippe auf einen Platz, um Möbel aus deinen Fundstücken zu bauen.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          HibernationCard(active: active),
        ],
      ),
    );
  }
}
