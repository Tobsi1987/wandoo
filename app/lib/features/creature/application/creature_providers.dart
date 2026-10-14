import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/creature/domain/creature.dart';
import 'package:wandoo/features/creature/domain/creature_repository.dart';
import 'package:wandoo/features/creature/domain/den_repository.dart';
import 'package:wandoo/features/creature/domain/feed_creature.dart';
import 'package:wandoo/features/creature/domain/marks_setting_repository.dart';

/// Wird in `bootstrap/providers.dart` mit einer Umsetzung belegt.
final creatureRepositoryProvider = Provider<CreatureRepository>(
  (ref) => throw UnimplementedError('In bootstrap/providers.dart setzen.'),
);

/// Das Wesen, aktuell gehalten bei jeder Fütterung.
final creatureProvider = StreamProvider<Creature>(
  (ref) => ref.watch(creatureRepositoryProvider).watch(),
);

/// Füttert nach jedem Gang; die Demo legt hier fest, was schlüpft.
final feedCreatureProvider = Provider<FeedCreature>((ref) => FeedCreature());

/// Wird in `bootstrap/providers.dart` mit einer Umsetzung belegt.
final denRepositoryProvider = Provider<DenRepository>(
  (ref) => throw UnimplementedError('In bootstrap/providers.dart setzen.'),
);

/// Wer gerade in der Höhle schläft.
final sleeperProvider = StreamProvider<Sleeper?>(
  (ref) => ref.watch(denRepositoryProvider).watch(),
);

/// Wird in `bootstrap/providers.dart` mit einer Umsetzung belegt.
final marksSettingRepositoryProvider = Provider<MarksSettingRepository>(
  (ref) => throw UnimplementedError('In bootstrap/providers.dart setzen.'),
);

/// Ob das Wesen die Spuren der Welt zeigt (sonst sieht es normal aus).
final marksShownProvider = StreamProvider<bool>(
  (ref) => ref.watch(marksSettingRepositoryProvider).watchShown(),
);
