import 'package:geo_engine/geo_engine.dart';

/// Eine Straße in einem Viertel und wie viel davon man schon kennt.
class DistrictStreet {
  const DistrictStreet({
    required this.name,
    required this.meters,
    required this.knownMeters,
  });

  final String name;
  final double meters;
  final double knownMeters;

  int get percent =>
      meters == 0 ? 0 : (knownMeters / meters * 100 + 1e-6).floor();

  bool get done => percent >= 100;
}

/// Die Straßen mit Namen aus den Wegstücken, A bis Z. Wege ohne Namen (sie
/// heißen nur nach ihrer OSM-Nummer, z. B. `w123`) zählen in
/// `unnamedMeters`.
class DistrictStreets {
  DistrictStreets(Iterable<RoadSegment> segments, Set<String> knownIds) {
    final total = <String, double>{};
    final known = <String, double>{};
    for (final s in segments) {
      if (_osmNumber.hasMatch(s.streetId)) {
        unnamedMeters += s.lengthMeters;
        continue;
      }
      total.update(
        s.streetId,
        (m) => m + s.lengthMeters,
        ifAbsent: () => s.lengthMeters,
      );
      if (knownIds.contains(s.id)) {
        known.update(
          s.streetId,
          (m) => m + s.lengthMeters,
          ifAbsent: () => s.lengthMeters,
        );
      }
    }
    named = [
      for (final e in total.entries)
        DistrictStreet(
          name: e.key,
          meters: e.value,
          knownMeters: known[e.key] ?? 0,
        ),
    ]..sort((a, b) => a.name.compareTo(b.name));
  }

  static final _osmNumber = RegExp(r'^w\d+$');

  late final List<DistrictStreet> named;

  /// Länge der Wege ohne Namen (Fußwege, Feldwege …).
  double unnamedMeters = 0;
}
