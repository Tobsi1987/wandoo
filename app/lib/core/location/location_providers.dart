import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/core/location/location_source.dart';

/// Wird in `bootstrap/providers.dart` mit einer Umsetzung belegt.
final locationSourceProvider = Provider<LocationSource>(
  (ref) => throw UnimplementedError('In bootstrap/providers.dart setzen.'),
);
