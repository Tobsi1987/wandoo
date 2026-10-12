import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/creature/domain/creature.dart';
import 'package:wandoo/features/creature/domain/creature_repository.dart';

/// Wird in `bootstrap/providers.dart` mit einer Umsetzung belegt.
final creatureRepositoryProvider = Provider<CreatureRepository>(
  (ref) => throw UnimplementedError('In bootstrap/providers.dart setzen.'),
);

final creatureProvider = FutureProvider<Creature>(
  (ref) => ref.watch(creatureRepositoryProvider).load(),
);
