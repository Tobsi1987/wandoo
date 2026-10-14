import 'dart:math' as math;

import 'package:vector_math/vector_math.dart' as vm;
import 'package:wandoo/features/creature/presentation/marks/mark_mesh.dart';
import 'package:wandoo/features/creature/presentation/marks/mark_surface.dart';
import 'package:wandoo/features/creature/presentation/model/model_anchors.dart';

/// Alles, was eine Spur zum Bauen braucht: die Stellen am Modell, wie groß
/// die Spur schon ist und ob auf dem Kopf Platz ist (kein Hut, keine Mütze).
class MarkSpot {
  MarkSpot(this.surface, this.anchors, this.level, {required this.headFree})
    : random = math.Random(level);

  final MarkSurface surface;
  final ModelAnchors anchors;

  /// 1 bis 3.
  final int level;
  final bool headFree;

  /// Gleiche Spur, gleiches Aussehen: der Zufall ist fest.
  final math.Random random;

  /// Kopfgröße im Verhältnis zu einem mittleren Kopf; Schmuck wächst mit.
  double get scale => anchors.headRadius / 0.28;

  /// Der innere Teil von [points]; [shares] gibt den Anteil je Stufe an.
  List<SurfacePoint> grown(List<SurfacePoint> points, List<double> shares) =>
      points.take((points.length * shares[level - 1]).ceil()).toList();

  /// Zufall zwischen [a] und [b].
  double between(double a, double b) => a + random.nextDouble() * (b - a);

  /// Ein Stück neben [p], seitlich auf der Haut verschoben.
  vm.Vector3 beside(SurfacePoint p, double dx, double dz, [double up = 0]) =>
      p.at + along(p.normal).rotated(vm.Vector3(dx, up, dz));

  /// Die Mitte oben auf dem Kopf, wo sonst der Hut sitzt.
  vm.Vector3 get crown => vm.Vector3(0, anchors.hatY, anchors.hatZ);
}
