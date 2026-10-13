import 'package:geo_engine/src/model/road_segment.dart';
import 'package:geo_engine/src/osm/area_tagger.dart';
import 'package:geo_engine/src/osm/overpass_parser.dart';
import 'package:geo_engine/src/osm/road_splitter.dart';

/// Macht aus einer Overpass-Antwort fertige Abschnitte mit Umgebung.
class RegionBuilder {
  const RegionBuilder({
    this.splitter = const RoadSplitter(),
    this.tagger = const AreaTagger(),
  });

  final RoadSplitter splitter;
  final AreaTagger tagger;

  List<RoadSegment> fromOverpassJson(String json) {
    final osm = OverpassParser.parse(json);
    return tagger.tag(splitter.split(osm.roads), osm);
  }
}
