/// Öffentliche Schnittstelle von `treasure`.
///
/// Nur exportieren, was andere Module wirklich brauchen.
library;

export 'application/treasure_providers.dart';
export 'domain/accessory.dart';
export 'domain/drop_finds.dart';
export 'domain/find.dart';
export 'domain/treasure_chest.dart';
export 'domain/treasure_repository.dart';
export 'presentation/treasure_labels.dart' show findEmoji, findNames, foundLine;
export 'presentation/treasure_screen.dart';
