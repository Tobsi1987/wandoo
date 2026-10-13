import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/creature/application/creature_providers.dart';
import 'package:wandoo/features/creature/domain/creature_repository.dart';
import 'package:wandoo/features/creature/domain/release_creature.dart';

/// Schickt das aktuelle Wesen weg und legt ein neues Ei hin.
class ReleaseCreatureAction {
  const ReleaseCreatureAction(
    this._repository, {
    this.rule = const ReleaseCreature(),
  });

  final CreatureRepository _repository;
  final ReleaseCreature rule;

  Future<void> call(DateTime now) async {
    final creature = await _repository.load();
    await _repository.save(rule(creature, now));
  }
}

final releaseCreatureProvider = Provider<ReleaseCreatureAction>(
  (ref) => ReleaseCreatureAction(ref.watch(creatureRepositoryProvider)),
);
