/// Öffentliche Schnittstelle von `friends`.
///
/// Nur exportieren, was andere Module wirklich brauchen.
library;

export 'application/friends_providers.dart'
    show friendsRepositoryProvider, myCardProvider, myWeekProvider;
export 'domain/friend.dart';
export 'domain/friend_card.dart';
export 'domain/friends_repository.dart';
export 'domain/my_week.dart';
export 'presentation/friends_screen.dart';
