import 'dart:io';

import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:path_provider/path_provider.dart';
import 'package:wandoo/core/database/app_database.dart';
import 'package:wandoo/core/database/database_providers.dart';
import 'package:wandoo/core/location/geolocator_location_source.dart';
import 'package:wandoo/core/location/location_providers.dart';
import 'package:wandoo/core/map_data/map_data_providers.dart';
import 'package:wandoo/core/map_data/overpass_client.dart';
import 'package:wandoo/core/map_data/tile_cache.dart';
import 'package:wandoo/core/map_data/tiled_map_data_source.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/creature/data/drift_creature_repository.dart';
import 'package:wandoo/features/discovery/data/drift_known_segments_repository.dart';
import 'package:wandoo/features/discovery/discovery.dart';
import 'package:wandoo/features/reminders/data/local_notification_scheduler.dart';
import 'package:wandoo/features/reminders/reminders.dart';
import 'package:wandoo/features/share/data/share_plus_image_sharer.dart';
import 'package:wandoo/features/share/share.dart';
import 'package:wandoo/features/tracking/data/drift_recorded_walk_repository.dart';
import 'package:wandoo/features/tracking/tracking.dart';
import 'package:wandoo/features/walk_summary/data/drift_walk_summary_repository.dart';
import 'package:wandoo/features/walk_summary/walk_summary.dart';

/// Kompositionswurzel: Hier und nur hier werden Schnittstellen mit
/// Umsetzungen verbunden.
Future<List<Override>> appOverrides() async {
  final db = AppDatabase.open();
  final support = await getApplicationSupportDirectory();
  final mapData = TiledMapDataSource(
    cache: TileCache(Directory('${support.path}/tiles')),
    fetch: OverpassClient().fetch,
  );
  return [
    appDatabaseProvider.overrideWithValue(db),
    creatureRepositoryProvider.overrideWithValue(DriftCreatureRepository(db)),
    knownSegmentsRepositoryProvider.overrideWithValue(
      DriftKnownSegmentsRepository(db),
    ),
    mapDataSourceProvider.overrideWithValue(mapData),
    locationSourceProvider.overrideWithValue(const GeolocatorLocationSource()),
    imageSharerProvider.overrideWithValue(const SharePlusImageSharer()),
    reminderSchedulerProvider.overrideWithValue(LocalNotificationScheduler()),
    recordedWalkRepositoryProvider.overrideWithValue(
      DriftRecordedWalkRepository(db),
    ),
    walkSummaryRepositoryProvider.overrideWithValue(
      DriftWalkSummaryRepository(db),
    ),
  ];
}
