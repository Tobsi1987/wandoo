import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:wandoo/bootstrap/demo/demo_den.dart';
import 'package:wandoo/bootstrap/demo/demo_platform.dart';
import 'package:wandoo/bootstrap/demo/demo_start.dart';
import 'package:wandoo/bootstrap/demo/demo_stats.dart';
import 'package:wandoo/bootstrap/demo/in_memory_recorded_walk_repository.dart';
import 'package:wandoo/bootstrap/demo/in_memory_walk_summary_repository.dart';
import 'package:wandoo/bootstrap/demo/simulated_location_source.dart';
import 'package:wandoo/core/location/location_providers.dart';
import 'package:wandoo/core/map_data/map_data_providers.dart';
import 'package:wandoo/features/achievements/achievements.dart';
import 'package:wandoo/features/achievements/data/in_memory_stats_repository.dart';
import 'package:wandoo/features/adventures/adventures.dart';
import 'package:wandoo/features/adventures/data/in_memory_adventure_repository.dart';
import 'package:wandoo/features/bath/bath.dart';
import 'package:wandoo/features/bath/data/in_memory_mud_repository.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/creature/data/in_memory_creature_repository.dart';
import 'package:wandoo/features/creature/data/in_memory_den_repository.dart';
import 'package:wandoo/features/creature/data/in_memory_marks_setting_repository.dart';
import 'package:wandoo/features/den/data/in_memory_room_repository.dart';
import 'package:wandoo/features/den/den.dart';
import 'package:wandoo/features/diary/data/in_memory_diary_repository.dart';
import 'package:wandoo/features/diary/diary.dart';
import 'package:wandoo/features/discovery/data/in_memory_known_segments_repository.dart';
import 'package:wandoo/features/discovery/discovery.dart';
import 'package:wandoo/features/discovery_map/discovery_map.dart';
import 'package:wandoo/features/home_widget/home_widget.dart';
import 'package:wandoo/features/hunger/data/in_memory_belly_repository.dart';
import 'package:wandoo/features/hunger/hunger.dart';
import 'package:wandoo/features/levels/data/in_memory_progress_repository.dart';
import 'package:wandoo/features/levels/levels.dart';
import 'package:wandoo/features/petting/data/in_memory_friendship_repository.dart';
import 'package:wandoo/features/petting/petting.dart';
import 'package:wandoo/features/privacy/data/in_memory_privacy_repository.dart';
import 'package:wandoo/features/privacy/privacy.dart';
import 'package:wandoo/features/reminders/reminders.dart';
import 'package:wandoo/features/scent/data/in_memory_scent_repository.dart';
import 'package:wandoo/features/scent/scent.dart';
import 'package:wandoo/features/share/data/share_plus_image_sharer.dart';
import 'package:wandoo/features/share/share.dart';
import 'package:wandoo/features/shop/data/in_memory_shop_repository.dart';
import 'package:wandoo/features/shop/shop.dart';
import 'package:wandoo/features/sounds/data/audioplayers_sound_player.dart';
import 'package:wandoo/features/sounds/data/in_memory_sound_settings_repository.dart';
import 'package:wandoo/features/sounds/sounds.dart';
import 'package:wandoo/features/star_catch/data/in_memory_star_catch_repository.dart';
import 'package:wandoo/features/star_catch/star_catch.dart';
import 'package:wandoo/features/tracking/tracking.dart';
import 'package:wandoo/features/treasure/data/in_memory_treasure_repository.dart';
import 'package:wandoo/features/treasure/treasure.dart';
import 'package:wandoo/features/walk_summary/walk_summary.dart';
import 'package:wandoo/features/world/world.dart';
import 'package:wandoo/flows/shop/shop_offers_provider.dart';

/// Wie `appOverrides`, aber alles im Speicher und ohne Gerät: eine erfundene
/// Stadt, simulierte Gänge, keine Datenbank, kein Netz.
List<Override> demoOverrides() {
  final scents = InMemoryScentRepository();
  final privacy = InMemoryPrivacyRepository(demoPrivacy());
  return [
    privacyRepositoryProvider.overrideWithValue(privacy),
    dataWiperProvider.overrideWithValue(DemoWiper(privacy)),
    shopRepositoryProvider.overrideWithValue(InMemoryShopRepository()),
    shopOffersProvider.overrideWith((ref) => ref.watch(liveShopOffersProvider)),
    ..._stores(),
    scentRepositoryProvider.overrideWithValue(scents),
    soundPlayerProvider.overrideWithValue(AudioplayersSoundPlayer()),
    soundSettingsRepositoryProvider.overrideWithValue(
      InMemorySoundSettingsRepository(),
    ),
    starCatchRepositoryProvider.overrideWithValue(
      InMemoryStarCatchRepository(),
    ),
    bellyRepositoryProvider.overrideWithValue(
      InMemoryBellyRepository([?demoBelly()]),
    ),
    progressRepositoryProvider.overrideWithValue(
      InMemoryProgressRepository([?demoProgress()]),
    ),
    statsRepositoryProvider.overrideWithValue(
      InMemoryStatsRepository(demoStats()),
    ),
    locationSourceProvider.overrideWithValue(
      SimulatedLocationSource(goal: () => scents.current?.target),
    ),
  ];
}

List<Override> _stores() => [
  creatureRepositoryProvider.overrideWithValue(
    InMemoryCreatureRepository(demoCreature()),
  ),
  denRepositoryProvider.overrideWithValue(InMemoryDenRepository()),
  marksSettingRepositoryProvider.overrideWithValue(
    InMemoryMarksSettingRepository(),
  ),
  mudRepositoryProvider.overrideWithValue(InMemoryMudRepository(demoMud())),
  knownSegmentsRepositoryProvider.overrideWithValue(
    InMemoryKnownSegmentsRepository(),
  ),
  mapDataSourceProvider.overrideWithValue(DemoMapData()),
  showBaseMapProvider.overrideWithValue(false),
  imageSharerProvider.overrideWithValue(const SharePlusImageSharer()),
  reminderSchedulerProvider.overrideWithValue(LoggingReminderScheduler()),
  widgetPublisherProvider.overrideWithValue(LoggingWidgetPublisher()),
  recordedWalkRepositoryProvider.overrideWithValue(
    InMemoryRecordedWalkRepository(),
  ),
  walkSummaryRepositoryProvider.overrideWithValue(
    InMemoryWalkSummaryRepository(),
  ),
  treasureRepositoryProvider.overrideWithValue(
    InMemoryTreasureRepository(demoChest()),
  ),
  roomRepositoryProvider.overrideWithValue(InMemoryRoomRepository(demoRoom())),
  adventureRepositoryProvider.overrideWithValue(InMemoryAdventureRepository()),
  diaryRepositoryProvider.overrideWithValue(InMemoryDiaryRepository()),
  friendshipRepositoryProvider.overrideWithValue(
    InMemoryFriendshipRepository(),
  ),
  if (demoHatches() case final id?)
    feedCreatureProvider.overrideWithValue(
      FeedCreature(hatchFrom: [SpeciesCatalog.byId(id)]),
    ),
  if (demoWeather() case final weather?)
    weatherSourceProvider.overrideWithValue(FixedWeather(weather)),
  if (demoHour() case final hour?)
    worldClockProvider.overrideWithValue(() {
      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day, hour, now.minute);
    }),
];
