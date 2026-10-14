/// Öffentliche Schnittstelle von `creature`.
///
/// Nur exportieren, was andere Module wirklich brauchen.
library;

export 'application/creature_providers.dart';
export 'domain/creature.dart';
export 'domain/creature_repository.dart';
export 'domain/den_repository.dart';
export 'domain/feed_creature.dart';
export 'domain/growth_stage.dart';
export 'domain/outfit.dart';
export 'domain/rarity.dart';
export 'domain/release_creature.dart';
export 'domain/species.dart';
export 'domain/species_catalog.dart';
export 'domain/trait.dart';
export 'presentation/album_screen.dart';
export 'presentation/creature_card.dart';
export 'presentation/creature_labels.dart';
export 'presentation/widgets/celebration_stage.dart';
export 'presentation/widgets/creature_avatar.dart';
export 'presentation/widgets/creature_figure.dart';
export 'presentation/widgets/model_motions.dart' show CreatureMotion, Motion;
