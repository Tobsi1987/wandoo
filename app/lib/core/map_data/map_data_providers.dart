import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/core/map_data/map_data_source.dart';

/// Wird in `bootstrap/providers.dart` mit einer Umsetzung belegt.
final mapDataSourceProvider = Provider<MapDataSource>(
  (ref) => throw UnimplementedError('In bootstrap/providers.dart setzen.'),
);
