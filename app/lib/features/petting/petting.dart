/// Öffentliche Schnittstelle von `petting`.
///
/// Nur exportieren, was andere Module wirklich brauchen.
library;

export 'application/petting_providers.dart'
    show
        befriendCreatureProvider,
        friendshipProvider,
        friendshipRepositoryProvider;
export 'domain/befriend_creature.dart';
export 'domain/friendship.dart';
export 'domain/friendship_repository.dart';
export 'presentation/widgets/floating_hearts.dart';
export 'presentation/widgets/hearts_bar.dart';
export 'presentation/widgets/pettable.dart';
