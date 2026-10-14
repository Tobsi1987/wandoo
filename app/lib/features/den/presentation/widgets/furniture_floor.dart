import 'package:flutter_scene/scene.dart';
import 'package:wandoo/features/den/presentation/widgets/piece_parts.dart';

// Betten und Pflanzen.

void hayNest(Node root) {
  root
    ..add(piece(tube(0.36, 0.08), paint(0xC9A44C), V(0, 0.05, 0)))
    ..add(
      piece(
        donut(0.36, 0.13),
        paint(0xE2BE5A),
        V(0, 0.13, 0),
        scale: V(1, 0.8, 0.8),
      ),
    );
  final straw = paint(0xF2D27A);
  for (var i = 0; i < 10; i++) {
    root.add(
      piece(
        tube(0.012, 0.22),
        straw,
        onFloor(i / 10, 0.4, V(0, 0.2, 0)) * 1,
        rotation: turn(V(0, 0, 1), 0.6 + i * 0.4),
      ),
    );
  }
  root.add(
    piece(
      ball(0.15),
      paint(0xF4A8B6),
      V(-0.2, 0.2, -0.05),
      scale: V(1.2, 0.6, 0.9),
    ),
  );
}

void shellBed(Node root) {
  final pink = paint(0xF7C6C7);
  root
    ..add(
      piece(
        tube(0.42, 0.14, top: 0.46),
        pink,
        V(0, 0.07, 0),
        scale: V(1, 1, 0.8),
      ),
    )
    ..add(
      piece(
        ball(0.42),
        paint(0xF4A8B6),
        V(0, 0.36, -0.28),
        scale: V(1, 0.8, 0.22),
      ),
    )
    ..add(
      piece(
        tube(0.38, 0.05),
        paint(0xFFF5EC),
        V(0, 0.16, 0.02),
        scale: V(1, 1, 0.75),
      ),
    )
    ..add(
      piece(
        ball(0.13),
        paint(0xFFFFFF),
        V(-0.18, 0.24, -0.1),
        scale: V(1.3, 0.6, 0.8),
      ),
    );
  final rib = paint(0xE88FA0);
  for (var i = 0; i < 7; i++) {
    final at = onWall(-0.2 + i * 0.067, 0.4, V(0, 0.36, -0.24));
    root.add(piece(ball(0.05), rib, at, scale: V(1, 1, 0.6)));
  }
}

void cloudBed(Node root) {
  final cloud = paint(0xFFFFFF);
  final gold = paint(0xE8B93E);
  for (final x in [-0.32, 0.32]) {
    for (final z in [-0.18, 0.18]) {
      root.add(piece(tube(0.03, 0.14), gold, V(x, 0.07, z)));
    }
  }
  const puffs = [
    (-0.28, 0.22, 0.17),
    (0.0, 0.24, 0.2),
    (0.28, 0.22, 0.17),
    (-0.14, 0.32, 0.15),
    (0.16, 0.33, 0.16),
    (-0.36, 0.4, 0.13),
  ];
  for (final (x, y, r) in puffs) {
    root.add(piece(ball(r), cloud, V(x, y, 0), scale: V(1, 0.8, 1.1)));
  }
  root.add(piece(ball(0.04), paint(0xFFE07A, glow: 1.5), V(0.3, 0.5, 0.05)));
}

void flowerPot(Node root) => _flowerPot(grow(root, 1.35));

void _flowerPot(Node root) {
  root
    ..add(piece(tube(0.12, 0.24, top: 0.16), paint(0xC8693F), V(0, 0.12, 0)))
    ..add(piece(tube(0.15, 0.02), paint(0x6B4A32), V(0, 0.24, 0)));
  final stem = paint(0x5E9E3A);
  final heads = [paint(0xE0454B), paint(0xF4A8B6), paint(0xF08A4B)];
  const flowers = [(-0.08, 0.5, -0.2), (0.0, 0.6, 0.0), (0.09, 0.48, 0.25)];
  for (var i = 0; i < flowers.length; i++) {
    final (x, y, tilt) = flowers[i];
    root
      ..add(
        piece(
          tube(0.012, y - 0.24),
          stem,
          V(x / 2, (y + 0.24) / 2, 0),
          rotation: turn(V(0, 0, 1), tilt),
        ),
      )
      ..add(piece(ball(0.07), heads[i], V(x, y, 0), scale: V(1, 0.7, 1)))
      ..add(piece(ball(0.03), paint(0xFFD54A), V(x, y + 0.03, 0.03)));
  }
}

void fern(Node root) => _fern(grow(root, 1.2));

void _fern(Node root) {
  root
    ..add(piece(tube(0.13, 0.22, top: 0.16), paint(0x6FA8B8), V(0, 0.11, 0)))
    ..add(piece(tube(0.15, 0.02), paint(0x6B4A32), V(0, 0.22, 0)));
  final greens = [paint(0x4A7F2C), paint(0x6BAA3E)];
  for (var i = 0; i < 9; i++) {
    final share = i / 9;
    final tip = onFloor(share, 0.2, V(0, 0.42 + (i % 3) * 0.05, 0));
    root.add(
      piece(
        ball(0.2),
        greens[i % 2],
        tip,
        scale: V(0.22, 0.95, 0.12),
        rotation: turn(V(0, 1, 0), share * 6.28) * turn(V(1, 0, 0), 0.6),
      ),
    );
  }
}

void waterLily(Node root) {
  root
    ..add(piece(tube(0.36, 0.14, top: 0.4), paint(0x8FB9D6), V(0, 0.07, 0)))
    ..add(piece(tube(0.36, 0.01), paint(0x4C9BD1), V(0, 0.145, 0)));
  final pad = paint(0x5E9E3A);
  for (final (x, z) in [(-0.2, 0.05), (0.18, -0.1), (0.12, 0.2)]) {
    root.add(piece(tube(0.1, 0.012), pad, V(x, 0.155, z)));
  }
  final petal = paint(0xF4A8B6);
  for (var i = 0; i < 7; i++) {
    final at = onFloor(i / 7, 0.07, V(0, 0.22, 0));
    root.add(piece(ball(0.06), petal, at, scale: V(0.6, 1, 0.6)));
  }
  root.add(piece(ball(0.04), paint(0xFFD54A), V(0, 0.24, 0)));
}
