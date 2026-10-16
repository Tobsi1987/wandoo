import 'dart:math' as math;

import 'package:flutter_scene/scene.dart';
import 'package:wandoo/features/den/presentation/widgets/piece_parts.dart';

// Was an der Wand hängt und die Lampen auf dem Regal.

void leafWreath(Node root) {
  final center = V(0, 0.5, 0);
  root.add(
    piece(donut(0.3, 0.06), paint(0x6E8B3D), center, rotation: faceFront),
  );
  final greens = [paint(0x5E9E3A), paint(0x8CC152), paint(0x4A7F2C)];
  for (var i = 0; i < 14; i++) {
    root.add(
      piece(
        ball(0.075),
        greens[i % 3],
        onWall(i / 14, 0.3, center) + V(0, 0, 0.04),
        scale: V(1.3, 0.8, 0.6),
        rotation: turn(V(0, 0, 1), i / 14 * 6.28),
      ),
    );
  }
  final berry = paint(0xE0454B);
  for (final s in [0.1, 0.35, 0.6, 0.85]) {
    root.add(piece(ball(0.04), berry, onWall(s, 0.3, center) + V(0, 0, 0.1)));
  }
  final bow = paint(0xE86A92);
  for (final side in [-1.0, 1.0]) {
    root.add(
      piece(
        ball(0.08),
        bow,
        center + V(side * 0.08, -0.3, 0.1),
        scale: V(1.3, 0.8, 0.5),
      ),
    );
  }
}

void shellGarland(Node root) {
  final string = paint(0x9C7B5B);
  final shells = [paint(0xF7C6C7), paint(0xFCE9D2), paint(0xF4A8B6)];
  final poppy = paint(0xE0454B);
  for (var i = 0; i <= 20; i++) {
    final x = -0.45 + i * 0.045;
    root.add(piece(ball(0.02), string, V(x, _sag(x), 0)));
  }
  for (var i = 0; i < 7; i++) {
    final x = -0.36 + i * 0.12;
    final at = V(x, _sag(x) - 0.09, 0.03);
    if (i.isEven) {
      root.add(piece(ball(0.07), shells[i % 3], at, scale: V(1, 1.1, 0.45)));
    } else {
      root.add(piece(ball(0.065), poppy, at + V(0, 0.02, 0)));
    }
  }
}

double _sag(double x) => 0.62 - 0.22 * (1 - x * x / 0.2025);

void starPicture(Node root) {
  root
    ..add(piece(box(0.78, 0.6, 0.05), paint(0xB07A45), V(0, 0.5, 0)))
    ..add(piece(box(0.66, 0.48, 0.02), paint(0x23305E), V(0, 0.5, 0.03)));
  final star = paint(0xFFE07A, glow: 1.4);
  const dots = [
    (-0.22, 0.6, 0.035),
    (-0.1, 0.66, 0.025),
    (0.05, 0.58, 0.05),
    (0.18, 0.66, 0.025),
    (0.24, 0.42, 0.03),
    (-0.18, 0.38, 0.025),
    (0.02, 0.36, 0.02),
  ];
  for (final (x, y, r) in dots) {
    root.add(piece(ball(r), star, V(x, y, 0.05)));
  }
}

void glowJar(Node root) => _glowJar(grow(root, 1.3));

void _glowJar(Node root) {
  root
    ..add(
      piece(
        tube(0.17, 0.42, top: 0.15),
        paint(0xFFE9A8, glow: 0.9),
        V(0, 0.23, 0),
      ),
    )
    ..add(piece(tube(0.12, 0.08), paint(0x9C6B3F), V(0, 0.48, 0)))
    ..add(
      piece(
        donut(0.09, 0.015),
        paint(0x7A5235),
        V(0, 0.58, 0),
        rotation: faceFront,
      ),
    );
  final fly = paint(0xFFF6C9, glow: 2);
  for (final (x, y) in [
    (-0.07, 0.15),
    (0.06, 0.28),
    (-0.02, 0.36),
    (0.08, 0.12),
  ]) {
    root.add(piece(ball(0.03), fly, V(x, y, 0.15)));
  }
}

void mushroomLamp(Node root) => _mushroomLamp(grow(root, 1.2));

void _mushroomLamp(Node root) {
  root
    ..add(piece(tube(0.08, 0.36, top: 0.06), paint(0xF5EBDD), V(0, 0.18, 0)))
    ..add(
      piece(
        ball(0.3),
        paint(0xF08A4B, glow: 0.5),
        V(0, 0.4, 0),
        scale: V(1, 0.6, 1),
      ),
    );
  final dot = paint(0xFFF8EE);
  for (var i = 0; i < 6; i++) {
    final at = onFloor(i / 6 + 0.05, 0.19, V(0, 0.52, 0));
    root.add(piece(ball(0.04), dot, at, scale: V(1, 0.5, 1)));
  }
}

void moonLamp(Node root) {
  final wood = paint(0xB07A45);
  root
    ..add(piece(tube(0.2, 0.05), wood, V(0, 0.025, 0)))
    ..add(piece(tube(0.025, 0.3), wood, V(0, 0.18, 0)))
    ..add(piece(ball(0.2), paint(0xFFF1B8, glow: 1.1), V(0, 0.5, 0)));
  final star = paint(0xFFE07A, glow: 1.5);
  for (final (x, y) in [(-0.27, 0.66), (0.26, 0.36), (0.22, 0.72)]) {
    root.add(piece(ball(0.03), star, V(x, y, 0)));
  }
}

/// Nachthimmel mit Sternen für den gekauften Goldrahmen
/// (`assets/den/starPicture.glb`: 1,13 breit, 1 hoch, Öffnung in der Mitte).
void starPictureSky(Node root) {
  root.add(piece(box(0.84, 0.66, 0.01), paint(0x23305E), V(0, 0.51, -0.01)));
  final glow = paint(0xFFE07A, glow: 1.4);
  const dots = [
    (-0.3, 0.68, 0.025),
    (-0.18, 0.36, 0.02),
    (0.28, 0.7, 0.02),
    (0.3, 0.34, 0.025),
    (-0.32, 0.46, 0.015),
    (0.12, 0.74, 0.015),
  ];
  for (final (x, y, r) in dots) {
    root.add(piece(ball(r), glow, V(x, y, 0.005)));
  }
  _star(root, V(0, 0.51, 0.04), 0.17, glow);
}

/// Ein dicker, leuchtender Stern aus fünf Zacken.
void _star(Node root, V center, double size, Material material) {
  root.add(piece(ball(size * 0.42), material, center, scale: V(1, 1, 0.5)));
  for (var i = 0; i < 5; i++) {
    final a = i / 5 * 2 * math.pi;
    root.add(
      piece(
        tube(size * 0.28, size * 0.75, top: size * 0.04),
        material,
        center + V(math.sin(a), math.cos(a), 0) * (size * 0.55),
        scale: V(1, 1, 0.45),
        rotation: turn(V(0, 0, 1), -a),
      ),
    );
  }
}
