import 'dart:developer' as developer;
import 'dart:math';

import 'package:geo_engine/geo_engine.dart';
import 'package:wandoo/core/map_data/map_data_source.dart';
import 'package:wandoo/features/discovery/discovery.dart';
import 'package:wandoo/features/environment/environment.dart';
import 'package:wandoo/features/scent/scent.dart';

/// Lässt das Wesen eine neue Spur erschnüffeln: eine unbekannte Straße in
/// Gehweite von [GeoPoint here].
///
/// Eine Spur bleibt, bis sie gefunden ist. Nur wenn sie alt ist oder weit
/// weg (man ist woanders unterwegs), wird neu geschnüffelt.
class SniffOut {
  SniffOut({
    required this.mapData,
    required this.known,
    required this.classify,
    required this.scents,
    this.pick = const PickScent(),
    this.maxAge = const Duration(days: 3),
    this.maxMeters = 1500,
    Random? random,
  }) : _random = random ?? Random();

  final MapDataSource mapData;
  final KnownSegmentsRepository known;
  final ClassifySegments classify;
  final ScentRepository scents;
  final PickScent pick;
  final Duration maxAge;
  final double maxMeters;
  final Random _random;

  /// Gibt die gültige Spur zurück, neu erschnüffelt falls nötig.
  Future<Scent?> call(GeoPoint here, DateTime now) async {
    final current = await scents.load();
    if (current != null && _stillGood(current, here, now)) return current;
    try {
      final scent = pick(here, await _unknownNear(here), now, _random);
      if (scent == null) return current;
      await scents.save(scent);
      return scent;
    } on Object catch (error, stack) {
      developer.log(
        'Spürnase konnte nichts riechen.',
        name: 'wandoo.scent',
        error: error,
        stackTrace: stack,
      );
      return current;
    }
  }

  bool _stillGood(Scent s, GeoPoint here, DateTime now) =>
      now.difference(s.createdAt) < maxAge &&
      s.target.distanceTo(here) <= maxMeters;

  Future<List<ScentSpot>> _unknownNear(GeoPoint here) async {
    final segments = await mapData.segmentsNear([here]);
    final knownIds = await known.knownIds();
    final fresh = [
      for (final s in segments)
        if (!knownIds.contains(s.id)) s,
    ];
    return [
      for (final MapEntry(key: s, value: type) in classify.each(fresh).entries)
        (at: _middle(s), environment: type),
    ];
  }

  static GeoPoint _middle(RoadSegment s) => GeoPoint(
    (s.start.latitude + s.end.latitude) / 2,
    (s.start.longitude + s.end.longitude) / 2,
  );
}
