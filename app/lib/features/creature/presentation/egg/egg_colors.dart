import 'dart:math' as math;
import 'dart:ui';

import 'package:vector_math/vector_math.dart' as vm;

// Farben der Eierschale, wie bisher in `shaders/egg_themes.glsl`.
// q ist die Richtung vom Ei-Mittelpunkt (Länge 1), theme die Nummer aus
// dem Shader: 0 schlicht, sonst EggTheme-Index + 1.

final _pink = vm.Vector3(1, 0.6, 0.72);
final _leaf = vm.Vector3(0.42, 0.72, 0.32);
final _white = vm.Vector3(0.99, 0.97, 0.94);
final _glow = vm.Vector3(1, 0.85, 0.35);
final _shell = vm.Vector3(0.98, 0.95, 0.88);
final _dark = vm.Vector3(0.13, 0.1, 0.16);

/// Farbe der Schale in Richtung [q]; [accent] färbt die Tupfen des
/// schlichten Eis, [crack] zeigt den Riss kurz vor dem Schlüpfen.
vm.Vector3 eggColor(
  vm.Vector3 q, {
  required int theme,
  required Color accent,
  bool crack = false,
}) {
  final col = theme > 0 ? _themed(q, theme) : _plain(q, accent);
  if (!crack) return col;
  final zig = ((_fract(math.atan2(q.x, q.z) * 1.6) - 0.5).abs()) * 0.12;
  final line = _smooth(0.035, 0.018, (q.y - 0.05 - zig).abs());
  return _mix(col, _dark, line);
}

vm.Vector3 _plain(vm.Vector3 q, Color accent) {
  final a = vm.Vector3(accent.r, accent.g, accent.b);
  var col = _shell;
  for (var i = 0; i < 6; i++) {
    final dir = vm.Vector3(
      math.sin(i * 2.4),
      math.cos(i * 1.7) * 0.8,
      math.cos(i * 2.4),
    )..normalize();
    col = _mix(col, a, _smooth(0.95, 0.97, q.dot(dir)));
  }
  return col;
}

vm.Vector3 _themed(vm.Vector3 q, int theme) => switch (theme) {
  1 => _spring(q),
  2 => _summer(q),
  3 => _autumn(q),
  4 => _winter(q),
  5 => _easter(q),
  6 => _halloween(q),
  _ => _christmas(q),
};

vm.Vector3 _spring(vm.Vector3 q) {
  final (d, w) = _dots(q, 10, 0.035);
  final dot = [_pink, _glow, vm.Vector3(0.75, 0.6, 0.95)][w];
  return _mix(vm.Vector3(0.9, 0.97, 0.85), dot, d);
}

vm.Vector3 _summer(vm.Vector3 q) {
  final zig = (_fract(math.atan2(q.x, q.z) * 1.9) - 0.5).abs() * 0.15;
  final band = _smooth(0.06, 0.04, (q.y - zig).abs());
  final band2 = _smooth(0.05, 0.03, (q.y - 0.4 + zig).abs());
  final col = _mix(vm.Vector3(1, 0.96, 0.8), vm.Vector3(1, 0.62, 0.3), band);
  return _mix(col, vm.Vector3(0.45, 0.75, 0.95), band2);
}

vm.Vector3 _autumn(vm.Vector3 q) {
  final (d, w) = _dots(q, 9, 0.05);
  final leaf = [
    vm.Vector3(0.95, 0.55, 0.2),
    vm.Vector3(0.85, 0.3, 0.2),
    vm.Vector3(0.65, 0.45, 0.25),
  ][w];
  return _mix(vm.Vector3(0.98, 0.9, 0.8), leaf, d);
}

vm.Vector3 _winter(vm.Vector3 q) {
  final band = _smooth(0.05, 0.03, (q.y + 0.1).abs());
  final col = _mix(
    vm.Vector3(0.86, 0.93, 1),
    vm.Vector3(0.55, 0.75, 0.95),
    band,
  );
  return _mix(col, _white, _dots(q, 14, 0.02).$1);
}

vm.Vector3 _easter(vm.Vector3 q) {
  final s = ((q.y + 1) * 4).floor() % 3;
  final col = [
    vm.Vector3(1, 0.8, 0.86),
    vm.Vector3(0.75, 0.95, 0.85),
    vm.Vector3(0.85, 0.8, 1),
  ][s];
  final edge = _smooth(0.42, 0.47, (_fract((q.y + 1) * 4) - 0.5).abs());
  return _mix(col, _glow, edge);
}

vm.Vector3 _halloween(vm.Vector3 q) {
  final ribs = 0.5 + 0.5 * math.cos(math.atan2(q.x, q.z) * 8);
  final col = _mix(
    vm.Vector3(1, 0.62, 0.25),
    vm.Vector3(0.92, 0.5, 0.18),
    ribs * 0.6,
  );
  return _mix(col, _leaf, _smooth(0.85, 0.9, q.y));
}

vm.Vector3 _christmas(vm.Vector3 q) {
  final band = _smooth(0.05, 0.03, q.y.abs());
  final col = _mix(vm.Vector3(0.88, 0.28, 0.3), vm.Vector3(1, 0.82, 0.3), band);
  return _mix(col, _white, _dots(q, 12, 0.022).$1);
}

/// Wie stark [q] in einem Tupfen liegt, und welche der drei Farben er hat.
(double, int) _dots(vm.Vector3 q, int count, double size) {
  var hit = 0.0;
  var which = 0;
  for (var i = 0; i < count; i++) {
    final dir = vm.Vector3(
      math.sin(i * 2.4),
      math.cos(i * 1.3) * 0.9,
      math.cos(i * 2.4),
    )..normalize();
    final s = _smooth(1 - size, 1 - size * 0.6, q.dot(dir));
    if (s > hit) {
      hit = s;
      which = i % 3;
    }
  }
  return (hit, which);
}

double _fract(double x) => x - x.floorToDouble();

double _smooth(double e0, double e1, double x) {
  final t = ((x - e0) / (e1 - e0)).clamp(0.0, 1.0);
  return t * t * (3 - 2 * t);
}

vm.Vector3 _mix(vm.Vector3 a, vm.Vector3 b, double t) => a * (1 - t) + b * t;
