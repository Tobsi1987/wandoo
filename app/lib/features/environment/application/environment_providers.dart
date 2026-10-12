import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/features/environment/domain/classify_segments.dart';

final classifySegmentsProvider = Provider<ClassifySegments>(
  (ref) => const ClassifySegments(),
);
