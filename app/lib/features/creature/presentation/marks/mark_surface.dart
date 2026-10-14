import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math.dart' as vm;

/// Ein Punkt auf der Haut eines Modells und wohin sie dort zeigt.
@immutable
class SurfacePoint {
  const SurfacePoint(this.at, this.normal);

  final vm.Vector3 at;
  final vm.Vector3 normal;
}

/// Wo auf einem Modell die Spuren der Welt sitzen können, abgemessen mit
/// `tool/measure_marks.mjs`. Jede Liste läuft von der Mitte nach außen, so
/// ist ein Anfang davon ein kleinerer Fleck.
@immutable
class MarkSurface {
  const MarkSurface({
    required this.top,
    required this.back,
    required this.ring,
    required this.shoulders,
    this.low = const [],
  });

  factory MarkSurface.fromJson(Map<String, dynamic> json) {
    List<SurfacePoint> points(String key) {
      final v = [for (final n in json[key] as List<dynamic>) (n as num) * 1.0];
      return [
        for (var i = 0; i + 5 < v.length; i += 6)
          SurfacePoint(
            vm.Vector3(v[i], v[i + 1], v[i + 2]),
            vm.Vector3(v[i + 3], v[i + 4], v[i + 5])..normalize(),
          ),
      ];
    }

    return MarkSurface(
      top: points('top'),
      back: points('back'),
      ring: points('ring'),
      shoulders: points('shoulders'),
      low: json.containsKey('low') ? points('low') : const [],
    );
  }

  /// Oben auf dem Kopf.
  final List<SurfacePoint> top;

  /// Mitte des Rückens.
  final List<SurfacePoint> back;

  /// Rund um den Kopf, etwas unter dem Scheitel (für einen Kranz).
  final List<SurfacePoint> ring;

  /// Rechte und linke Schulter.
  final List<SurfacePoint> shoulders;

  /// Beine und Bauch, vorne und hinten.
  final List<SurfacePoint> low;

  static const asset = 'assets/creatures/marks.json';

  static Map<String, MarkSurface>? _all;
  static Future<void>? _loading;

  /// Die Stellen für eine Art, sobald [load] fertig ist.
  static MarkSurface? of(String speciesId) => _all?[speciesId];

  static bool get isLoaded => _all != null;

  /// Lädt alle Arten einmal; fehlt die Datei, gibt es eben keine Spuren.
  static Future<void> load() => _loading ??= rootBundle
      .loadString(asset)
      .then(read, onError: (Object _) => read('{}'));

  @visibleForTesting
  static void read(String json) {
    final raw = jsonDecode(json) as Map<String, dynamic>;
    _all = {
      for (final e in raw.entries)
        e.key: MarkSurface.fromJson(e.value as Map<String, dynamic>),
    };
  }
}
