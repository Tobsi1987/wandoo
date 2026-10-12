/// Öffentliche Schnittstelle von geo_engine.
///
/// Nur was hier exportiert ist, darf die App benutzen. Alles unter `src/`
/// ist intern und darf jederzeit umgebaut werden.
library;

export 'src/classification/environment_classifier.dart';
export 'src/classification/osm_environment_rules.dart';
export 'src/matching/map_matcher.dart';
export 'src/matching/nearest_segment_matcher.dart';
export 'src/model/environment_type.dart';
export 'src/model/geo_point.dart';
export 'src/model/road_segment.dart';
export 'src/model/track.dart';
export 'src/novelty/novelty_evaluator.dart';
export 'src/novelty/novelty_result.dart';
