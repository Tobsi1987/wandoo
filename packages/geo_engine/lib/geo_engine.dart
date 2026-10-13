/// Öffentliche Schnittstelle von geo_engine.
///
/// Nur was hier exportiert ist, darf die App benutzen. Alles unter `src/`
/// ist intern und darf jederzeit umgebaut werden.
library;

export 'src/classification/environment_classifier.dart';
export 'src/classification/osm_environment_rules.dart';
export 'src/filtering/walking_filter.dart';
export 'src/gpx/gpx_codec.dart';
export 'src/matching/coverage_matcher.dart';
export 'src/matching/map_matcher.dart';
export 'src/model/environment_type.dart';
export 'src/model/geo_point.dart';
export 'src/model/road_segment.dart';
export 'src/model/track.dart';
export 'src/model/track_point.dart';
export 'src/novelty/novelty_evaluator.dart';
export 'src/novelty/novelty_result.dart';
export 'src/osm/overpass_query.dart';
export 'src/osm/region_builder.dart';
export 'src/quota/discovery_quota.dart';
export 'src/region/region_codec.dart';
