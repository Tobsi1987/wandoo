import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/districts/domain/district.dart';
import 'package:wandoo/features/districts/domain/district_progress.dart';

/// Das Puzzle einer Gegend: [side] × [side] Viertel, jedes ein Teil.
class Puzzle {
  const Puzzle({required this.pieces, required this.here});

  /// Baut das Puzzle der Gegend um [position].
  factory Puzzle.around(
    GeoPoint position,
    Iterable<RoadSegment> segments,
    Set<String> knownIds,
  ) {
    final here = District.containing(position);
    final top = _start(here.row) + side - 1;
    final left = _start(here.col);
    final states = const DistrictProgress()(segments, knownIds);
    return Puzzle(
      here: here,
      pieces: [
        for (var r = top; r > top - side; r--)
          for (var c = left; c < left + side; c++)
            states[District(r, c)] ??
                DistrictState(district: District(r, c), share: 0, meters: 0),
      ],
    );
  }

  static const side = 5;

  /// Alle Teile, Zeile für Zeile von Nordwest nach Südost.
  final List<DistrictState> pieces;

  /// Das Viertel, in dem man gerade steht.
  final District here;

  int get placed => pieces.where((p) => p.badge).length;

  int get placeable => pieces.where((p) => !p.wild).length;

  static int _start(int index) => (index / side).floor() * side;
}
