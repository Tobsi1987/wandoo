import 'package:flutter_scene/scene.dart';

/// Lädt 3D-Modelle einmal und merkt sie sich.
///
/// Fertig geladene Modelle gibt [ready] sofort heraus, damit eine neue
/// Figur nicht einen Augenblick lang leer oder falsch dasteht.
abstract final class ModelLoader {
  static final Future<bool> _scene = Scene.initializeStaticResources().then(
    (_) => true,
    onError: (Object _) => false,
  );
  static final _loading = <String, Future<Node?>>{};
  static final _done = <String, Node?>{};

  static Future<Node?> load(String asset) => _loading[asset] ??= _scene
      .then(
        (ok) => ok
            ? Node.fromGlbAsset(
                asset,
              ).then<Node?>((n) => n, onError: (_) => null)
            : null,
      )
      .then((node) => _done[asset] = node);

  /// Ob [asset] schon fertig ist, geladen oder gescheitert.
  static bool isDone(String asset) => _done.containsKey(asset);

  /// Das geladene Modell, null solange es lädt oder wenn es scheitert.
  static Node? ready(String asset) => _done[asset];
}
