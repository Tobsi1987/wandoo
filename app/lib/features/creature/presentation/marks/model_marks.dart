import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart' as vm;
import 'package:wandoo/features/creature/domain/trait.dart';
import 'package:wandoo/features/creature/domain/world_mark.dart';
import 'package:wandoo/features/creature/presentation/marks/mark_mesh.dart';
import 'package:wandoo/features/creature/presentation/marks/mark_spot.dart';
import 'package:wandoo/features/creature/presentation/marks/mark_surface.dart';
import 'package:wandoo/features/creature/presentation/marks/marks_city.dart';
import 'package:wandoo/features/creature/presentation/marks/marks_field.dart';
import 'package:wandoo/features/creature/presentation/marks/marks_forest.dart';
import 'package:wandoo/features/creature/presentation/marks/marks_mud.dart';
import 'package:wandoo/features/creature/presentation/marks/marks_water.dart';
import 'package:wandoo/features/creature/presentation/model/model_anchors.dart';

/// Baut die Spur der Welt für ein Modell: matte Teile, glänzende Schuppen
/// und leuchtende Lichter, jeweils als ein Netz.
Node? modelMarks(
  MarkSurface surface,
  ModelAnchors anchors,
  WorldMark mark, {
  required bool headFree,
}) {
  final spot = MarkSpot(surface, anchors, mark.level, headFree: headFree);
  final plain = MarkMesh();
  final shiny = MarkMesh();
  final glow = MarkMesh();
  switch (mark.trait) {
    case Trait.moss:
      forestMarks(spot, plain);
    case Trait.fins:
      waterMarks(spot, plain, shiny);
    case Trait.wheatEars:
      fieldMarks(spot, plain);
    case Trait.lanterns:
      cityMarks(spot, plain, glow);
  }
  return _root([
    ?plain.node(),
    ?shiny.node(roughness: 0.25),
    ?glow.node(glow: vm.Vector4(1, 0.62, 0.2, 1)),
  ]);
}

/// Matsch an Beinen und Bauch, [level] 1 bis 3.
Node? modelMud(MarkSurface surface, int level) {
  final mesh = MarkMesh();
  mudMarks(surface, level, mesh);
  return _root([?mesh.node(roughness: 1)]);
}

Node? _root(List<Node> parts) {
  if (parts.isEmpty) return null;
  // Wie die Wurzel eines glb: vorne (+z) zeigt zur Kamera.
  final root = Node(
    name: 'marks',
    localTransform: vm.Matrix4.diagonal3Values(1, 1, -1),
  );
  parts.forEach(root.add);
  return root;
}
