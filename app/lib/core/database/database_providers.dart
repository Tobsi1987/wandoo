import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/core/database/app_database.dart';

/// Wird in `bootstrap/providers.dart` mit der geöffneten Datenbank belegt.
final appDatabaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('In bootstrap/providers.dart setzen.'),
);
