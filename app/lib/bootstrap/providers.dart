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
import 'package:wandoo/features/adventures/adventures.dart';
import 'package:wandoo/features/adventures/data/drift_adventure_repository.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/creature/data/drift_creature_repository.dart';
import 'package:wandoo/features/creature/data/drift_den_repository.dart';
import 'package:wandoo/features/diary/data/drift_diary_repository.dart';
import 'package:wandoo/features/diary/diary.dart';
import 'package:wandoo/features/discovery/data/drift_known_segments_repository.dart';
import 'package:wandoo/features/discovery/discovery.dart';
import 'package:wandoo/features/home_widget/data/home_widget_publisher.dart';
import 'package:wandoo/features/home_widget/home_widget.dart';
import 'package:wandoo/features/hunger/data/drift_belly_repository.dart';
import 'package:wandoo/features/hunger/hunger.dart';
import 'package:wandoo/features/levels/data/drift_progress_repository.dart';
import 'package:wandoo/features/levels/levels.dart';
import 'package:wandoo/features/petting/data/drift_friendship_repository.dart';
import 'package:wandoo/features/petting/petting.dart';
import 'package:wandoo/features/reminders/data/local_notification_scheduler.dart';
import 'package:wandoo/features/reminders/reminders.dart';
import 'package:wandoo/features/scent/data/drift_scent_repository.dart';
import 'package:wandoo/features/scent/scent.dart';
import 'package:wandoo/features/share/data/share_plus_image_sharer.dart';
import 'package:wandoo/features/share/share.dart';
import 'package:wandoo/features/sounds/data/audioplayers_sound_player.dart';
import 'package:wandoo/features/sounds/data/drift_sound_settings_repository.dart';
import 'package:wandoo/features/sounds/sounds.dart';
import 'package:wandoo/features/star_catch/data/drift_star_catch_repository.dart';
import 'package:wandoo/features/star_catch/star_catch.dart';
import 'package:wandoo/features/tracking/data/drift_recorded_walk_repository.dart';
import 'package:wandoo/features/tracking/tracking.dart';
import 'package:wandoo/features/treasure/data/drift_treasure_repository.dart';
import 'package:wandoo/features/treasure/treasure.dart';
import 'package:wandoo/features/walk_summary/data/drift_walk_summary_repository.dart';
import 'package:wandoo/features/walk_summary/walk_summary.dart';
import 'package:wandoo/features/world/data/cached_weather_source.dart';
import 'package:wandoo/features/world/data/open_meteo_weather_source.dart';
import 'package:wandoo/features/world/world.dart';

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
    denRepositoryProvider.overrideWithValue(DriftDenRepository(db)),
    knownSegmentsRepositoryProvider.overrideWithValue(
      DriftKnownSegmentsRepository(db),
    ),
    mapDataSourceProvider.overrideWithValue(mapData),
    locationSourceProvider.overrideWithValue(const GeolocatorLocationSource()),
    imageSharerProvider.overrideWithValue(const SharePlusImageSharer()),
    reminderSchedulerProvider.overrideWithValue(LocalNotificationScheduler()),
    widgetPublisherProvider.overrideWithValue(const HomeWidgetPublisher()),
    recordedWalkRepositoryProvider.overrideWithValue(
      DriftRecordedWalkRepository(db),
    ),
    walkSummaryRepositoryProvider.overrideWithValue(
      DriftWalkSummaryRepository(db),
    ),
    treasureRepositoryProvider.overrideWithValue(DriftTreasureRepository(db)),
    adventureRepositoryProvider.overrideWithValue(DriftAdventureRepository(db)),
    diaryRepositoryProvider.overrideWithValue(DriftDiaryRepository(db)),
    friendshipRepositoryProvider.overrideWithValue(
      DriftFriendshipRepository(db),
    ),
    scentRepositoryProvider.overrideWithValue(DriftScentRepository(db)),
    soundPlayerProvider.overrideWithValue(AudioplayersSoundPlayer()),
    soundSettingsRepositoryProvider.overrideWithValue(
      DriftSoundSettingsRepository(db),
    ),
    starCatchRepositoryProvider.overrideWithValue(DriftStarCatchRepository(db)),
    bellyRepositoryProvider.overrideWithValue(DriftBellyRepository(db)),
    progressRepositoryProvider.overrideWithValue(DriftProgressRepository(db)),
    weatherSourceProvider.overrideWithValue(
      CachedWeatherSource(OpenMeteoWeatherSource()),
    ),
  ];
}
