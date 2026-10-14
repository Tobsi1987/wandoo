import 'package:flutter_scene/scene.dart';
import 'package:wandoo/features/den/presentation/widgets/piece_parts.dart';

// Teppiche und Spielzeug.

void flowerRug(Node root) {
  root.add(
    piece(tube(0.5, 0.02), paint(0xFCE9D2), V(0, 0.01, 0), scale: V(1, 1, 0.7)),
  );
  final colors = [paint(0xE0454B), paint(0xF4A8B6), paint(0xFFD54A)];
  for (var i = 0; i < 9; i++) {
    final at = onFloor(i / 9, 0.34, V(0, 0.025, 0));
    root.add(piece(tube(0.05, 0.01), colors[i % 3], V(at.x, at.y, at.z * 0.7)));
  }
  root.add(piece(tube(0.1, 0.01), paint(0xE0454B), V(0, 0.025, 0)));
}

void waveRug(Node root) {
  root.add(
    piece(tube(0.5, 0.02), paint(0x4C9BD1), V(0, 0.01, 0), scale: V(1, 1, 0.7)),
  );
  final light = paint(0xA9D6F2);
  for (final r in [0.18, 0.32, 0.44]) {
    root.add(
      piece(donut(r, 0.02), light, V(0, 0.022, 0), scale: V(1, 0.4, 0.7)),
    );
  }
}

void starRug(Node root) {
  root
    ..add(
      piece(
        tube(0.5, 0.02),
        paint(0x2E3B73),
        V(0, 0.01, 0),
        scale: V(1, 1, 0.7),
      ),
    )
    ..add(
      piece(
        donut(0.47, 0.025),
        paint(0xE8B93E),
        V(0, 0.02, 0),
        scale: V(1, 0.4, 0.7),
      ),
    );
  final star = paint(0xFFE07A, glow: 1.2);
  for (var i = 0; i < 8; i++) {
    final at = onFloor(i / 8 + 0.06, 0.12 + (i % 3) * 0.1, V(0, 0.025, 0));
    root.add(piece(ball(0.025), star, V(at.x, at.y, at.z * 0.7)));
  }
}

void beachBall(Node root) {
  final center = V(0, 0.25, 0);
  root.add(piece(ball(0.25), paint(0xE0454B), center));
  final white = paint(0xFFFFFF);
  final blue = paint(0x4C9BD1);
  root
    ..add(piece(donut(0.245, 0.04), white, center, rotation: faceFront))
    ..add(
      piece(
        donut(0.245, 0.04),
        blue,
        center,
        rotation: turn(V(0, 0, 1), 1.57) * faceFront,
      ),
    )
    ..add(piece(ball(0.04), paint(0xFFD54A), center + V(0, 0.24, 0)));
}

void spinningTop(Node root) {
  root
    ..add(piece(tube(0.03, 0.4, top: 0.36), paint(0x8CC152), V(0, 0.2, 0)))
    ..add(piece(tube(0.36, 0.1, top: 0.24), paint(0xF08A4B), V(0, 0.45, 0)))
    ..add(piece(donut(0.3, 0.035), paint(0xFFD54A), V(0, 0.34, 0)))
    ..add(piece(tube(0.035, 0.22), paint(0xB07A45), V(0, 0.6, 0)));
}

void toyBoat(Node root) => _toyBoat(grow(root, 1.4));

void _toyBoat(Node root) {
  root
    ..add(piece(box(0.6, 0.12, 0.24), paint(0xB07A45), V(0, 0.1, 0)))
    ..add(
      piece(
        tube(0.12, 0.6),
        paint(0xB07A45),
        V(0, 0.07, 0),
        rotation: turn(V(0, 0, 1), 1.57),
      ),
    )
    ..add(piece(box(0.64, 0.03, 0.26), paint(0xE0454B), V(0, 0.17, 0)))
    ..add(piece(tube(0.015, 0.5), paint(0x7A5235), V(0, 0.42, 0)))
    ..add(piece(box(0.26, 0.3, 0.01), paint(0xFFFFFF), V(0.13, 0.46, 0)))
    ..add(piece(box(0.1, 0.06, 0.01), paint(0x4C9BD1), V(0.05, 0.69, 0)));
}
