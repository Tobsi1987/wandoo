import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/districts/domain/district.dart';
import 'package:wandoo/features/districts/domain/district_progress.dart';

/// Das Puzzle einer Gegend: [side] × [side] Viertel, jedes ein Teil.
class Puzzle {
  const Puzzle({
    required this.pieces,
    required this.here,
    this.segments = const {},
    this.knownIds = const {},
  });

  /// Baut das Puzzle der Gegend um [position].
  factory Puzzle.around(
    GeoPoint position,
    Iterable<RoadSegment> segments,
    Set<String> knownIds,
  ) {
    final here = District.containing(position);
    final top = _start(here.row) + side - 1;
    final left = _start(here.col);
    final districts = [
      for (var r = top; r > top - side; r--)
        for (var c = left; c < left + side; c++) District(r, c),
    ];
    final inPuzzle = districts.toSet();
    final byDistrict = <District, List<RoadSegment>>{};
    for (final s in segments) {
      final d = District.of(s);
      if (inPuzzle.contains(d)) byDistrict.putIfAbsent(d, () => []).add(s);
    }
    final states = const DistrictProgress()(segments, knownIds);
    return Puzzle(
      here: here,
      segments: byDistrict,
      knownIds: knownIds,
      pieces: [
        for (final d in districts)
          states[d] ?? DistrictState(district: d, share: 0, meters: 0),
      ],
    );
  }

  static const side = 5;

  /// Alle Teile, Zeile für Zeile von Nordwest nach Südost.
  final List<DistrictState> pieces;

  /// Das Viertel, in dem man gerade steht.
  final District here;

  /// Die Wegstücke jedes Viertels im Puzzle.
  final Map<District, List<RoadSegment>> segments;

  /// IDs der Wegstücke, die man schon kennt.
  final Set<String> knownIds;

  int get placed => pieces.where((p) => p.badge).length;

  int get placeable => pieces.where((p) => !p.wild).length;

  static int _start(int index) => (index / side).floor() * side;
}
