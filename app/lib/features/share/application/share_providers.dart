import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/share/domain/image_sharer.dart';

/// Wird in `bootstrap/providers.dart` mit einer Umsetzung belegt.
final imageSharerProvider = Provider<ImageSharer>(
  (ref) => throw UnimplementedError('In bootstrap/providers.dart setzen.'),
);
