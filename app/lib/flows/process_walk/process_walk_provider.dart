import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/core/map_data/map_data_providers.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/discovery/discovery.dart';
import 'package:wandoo/features/environment/environment.dart';
import 'package:wandoo/features/tracking/tracking.dart';
import 'package:wandoo/flows/process_walk/pending_walk_processor.dart';
import 'package:wandoo/flows/process_walk/process_walk.dart';

final processWalkProvider = Provider<ProcessWalk>(
  (ref) => ProcessWalk(
    mapData: ref.watch(mapDataSourceProvider),
    discover: ref.watch(discoverSegmentsProvider),
    classify: ref.watch(classifySegmentsProvider),
    creatures: ref.watch(creatureRepositoryProvider),
  ),
);

final pendingWalkProcessorProvider = Provider<PendingWalkProcessor>(
  (ref) => PendingWalkProcessor(
    walks: ref.watch(recordedWalkRepositoryProvider),
    process: ref.watch(processWalkProvider),
  ),
);
