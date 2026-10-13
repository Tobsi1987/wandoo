import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/features/districts/domain/district.dart';

/// Wie weit ein Viertel entdeckt ist.
class DistrictState {
  const DistrictState({
    required this.district,
    required this.share,
    required this.meters,
  });

  /// Ab diesem Anteil gibt es Abzeichen und Puzzleteil.
  static const badgeShare = 0.8;

  /// Viertel mit weniger Wegen sind Wildnis: Wald, Wasser, Felder.
  static const wildBelowMeters = 300.0;

  final District district;

  /// Bekannter Anteil der Weglänge, 0 bis 1.
  final double share;

  /// Gesamte Weglänge im Viertel.
  final double meters;

  bool get wild => meters < wildBelowMeters;

  bool get badge => !wild && share >= badgeShare - 1e-9;

  int get percent => (share * 100).floor();
}

/// Rechnet für jedes Viertel aus, wie viel davon bekannt ist.
class DistrictProgress {
  const DistrictProgress();

  Map<District, DistrictState> call(
    Iterable<RoadSegment> segments,
    Set<String> knownIds,
  ) {
    final total = <District, double>{};
    final known = <District, double>{};
    for (final s in segments) {
      final d = District.of(s);
      total.update(
        d,
        (m) => m + s.lengthMeters,
        ifAbsent: () => s.lengthMeters,
      );
      if (knownIds.contains(s.id)) {
        known.update(
          d,
          (m) => m + s.lengthMeters,
          ifAbsent: () => s.lengthMeters,
        );
      }
    }
    return {
      for (final e in total.entries)
        e.key: DistrictState(
          district: e.key,
          share: e.value == 0 ? 0 : (known[e.key] ?? 0) / e.value,
          meters: e.value,
        ),
    };
  }

  /// Viertel, die mit [fresh] die Abzeichen-Grenze überschritten haben.
  List<District> newBadges(
    Iterable<RoadSegment> segments,
    Set<String> knownAfter,
    Set<String> fresh,
  ) {
    final touched = {
      for (final s in segments)
        if (fresh.contains(s.id)) District.of(s),
    };
    final inTouched = segments.where((s) => touched.contains(District.of(s)));
    final before = this(inTouched, knownAfter.difference(fresh));
    final after = this(inTouched, knownAfter);
    return [
      for (final d in touched)
        if (after[d]?.badge == true && before[d]?.badge != true) d,
    ];
  }
}
