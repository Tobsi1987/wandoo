import 'dart:io';

import 'package:flutter/services.dart';

/// Lädt Roboto aus dem Flutter-SDK, damit Texte im Test so breit sind wie
/// auf dem Handy (die Test-Schrift ist viel breiter). false, wenn sie fehlt.
Future<bool> loadRoboto() async {
  final cache = _cacheDir();
  if (cache == null) return false;
  final loader = FontLoader('Roboto');
  for (final w in ['Regular', 'Medium', 'Bold']) {
    final file = File('${cache.path}/artifacts/material_fonts/Roboto-$w.ttf');
    if (!file.existsSync()) return false;
    final bytes = await file.readAsBytes();
    loader.addFont(Future.value(ByteData.sublistView(bytes)));
  }
  await loader.load();
  return true;
}

/// `bin/cache` des SDK, gefunden über das laufende flutter_tester.
Directory? _cacheDir() {
  var dir = File(Platform.resolvedExecutable).parent;
  while (dir.parent.path != dir.path) {
    if (dir.path.endsWith('${Platform.pathSeparator}cache')) return dir;
    dir = dir.parent;
  }
  return null;
}
