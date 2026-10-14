import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/core/map_data/map_data_providers.dart';
import 'package:wandoo/features/adventures/adventures.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/diary/diary.dart';
import 'package:wandoo/features/discovery/discovery.dart';
import 'package:wandoo/features/environment/environment.dart';
import 'package:wandoo/features/petting/petting.dart';
import 'package:wandoo/features/scent/scent.dart';
import 'package:wandoo/features/tracking/tracking.dart';
import 'package:wandoo/features/treasure/treasure.dart';
import 'package:wandoo/features/walk_summary/walk_summary.dart';
import 'package:wandoo/flows/process_walk/extras/adventure_extra.dart';
import 'package:wandoo/flows/process_walk/extras/diary_extra.dart';
import 'package:wandoo/flows/process_walk/extras/district_extra.dart';
import 'package:wandoo/flows/process_walk/extras/friendship_extra.dart';
import 'package:wandoo/flows/process_walk/extras/scent_extra.dart';
import 'package:wandoo/flows/process_walk/extras/treasure_extra.dart';
import 'package:wandoo/flows/process_walk/pending_walk_processor.dart';
import 'package:wandoo/flows/process_walk/process_walk.dart';
import 'package:wandoo/flows/scent/sniff_out_provider.dart';

final processWalkProvider = Provider<ProcessWalk>(
  (ref) => ProcessWalk(
    mapData: ref.watch(mapDataSourceProvider),
    discover: ref.watch(discoverSegmentsProvider),
    classify: ref.watch(classifySegmentsProvider),
    creatures: ref.watch(creatureRepositoryProvider),
    summaries: ref.watch(walkSummaryRepositoryProvider),
    feed: ref.watch(feedCreatureProvider),
    extras: [
      DistrictExtra(ref.watch(knownSegmentsRepositoryProvider)),
      TreasureExtra(ref.watch(treasureRepositoryProvider)),
      AdventureExtra(
        adventures: ref.watch(adventureRepositoryProvider),
        chests: ref.watch(treasureRepositoryProvider),
        creatures: ref.watch(creatureRepositoryProvider),
      ),
      DiaryExtra(
        ref.watch(diaryRepositoryProvider),
        remember: ref.watch(rememberWalkProvider),
      ),
      FriendshipExtra(
        ref.watch(friendshipRepositoryProvider),
        rules: ref.watch(befriendCreatureProvider),
      ),
      ScentExtra(
        scents: ref.watch(scentRepositoryProvider),
        chests: ref.watch(treasureRepositoryProvider),
        sniff: ref.watch(sniffOutProvider),
      ),
    ],
  ),
);

final pendingWalkProcessorProvider = Provider<PendingWalkProcessor>(
  (ref) => PendingWalkProcessor(
    walks: ref.watch(recordedWalkRepositoryProvider),
    process: ref.watch(processWalkProvider),
  ),
);
