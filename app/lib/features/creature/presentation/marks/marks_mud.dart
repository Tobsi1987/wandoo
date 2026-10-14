import 'package:vector_math/vector_math.dart' as vm;
import 'package:wandoo/features/creature/presentation/marks/mark_mesh.dart';
import 'package:wandoo/features/creature/presentation/marks/mark_spot.dart';
import 'package:wandoo/features/creature/presentation/marks/mark_surface.dart';
import 'package:wandoo/features/creature/presentation/model/model_anchors.dart';

// Matsch: braune Spritzer an Beinen und Bauch, je schmutziger, desto mehr
// und desto höher hinauf.

const _mud = [0x9b7653, 0x8a6542, 0xa8835c];

/// [level] 1 bis 3.
void mudMarks(MarkSurface surface, int level, MarkMesh mesh) {
  final spot = MarkSpot(surface, ModelAnchors.fallback, level, headFree: false);
  final low = [...surface.low]..shuffle(spot.random);
  final count = (low.length * const [0.12, 0.25, 0.4][level - 1]).round();
  for (final p in low.take(count)) {
    _splat(spot, mesh, p);
  }
  if (level == 3) {
    for (final p in surface.top.take(6)) {
      _splat(spot, mesh, p);
    }
  }
}

void _splat(MarkSpot s, MarkMesh mesh, SurfacePoint p) {
  final r = s.between(0.018, 0.034);
  final color = _mud[s.random.nextInt(_mud.length)];
  mesh.blob(
    p.at + p.normal * 0.002,
    along(p.normal, s.between(0, 6.3)),
    vm.Vector3(r, r * 0.22, r * s.between(0.6, 1)),
    color,
  );
  for (var k = 0; k < 2; k++) {
    mesh.ball(
      s.beside(p, s.between(-1, 1) * r * 1.6, s.between(-1, 1) * r * 1.6),
      r * 0.3,
      color,
    );
  }
}
