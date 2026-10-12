// Prüft die Architekturregeln von Wandoo. Aufruf aus der Repo-Wurzel:
//
//   dart tool/check_architecture.dart
//
// Regeln (siehe docs/architecture.md):
//   * Dateigröße: Warnung über 200 Zeilen, Fehler über 300.
//   * Funktionslänge: Fehler über 50 Zeilen, build() über 60.
//   * Importe: nur nach unten, Features nur über ihre öffentliche Datei.
// Ausnahme: `// arch-ignore: <Grund>` in der Importzeile.
import 'dart:io';

const fileWarnLines = 200;
const fileMaxLines = 300;
const functionMaxLines = 50;
const buildMaxLines = 60;

final errors = <String>[];
final warnings = <String>[];
var ignored = 0;

void main(List<String> args) {
  final root = Directory(args.isEmpty ? '.' : args.first).absolute.path;
  final appLib = '$root/app/lib';
  for (final file in _dartFiles('$root/app/lib')) {
    final lines = File(file).readAsLinesSync();
    final rel = _rel(file, root);
    _checkSizes(rel, lines);
    _checkAppImports(rel, file, lines, appLib);
  }
  for (final file in _dartFiles('$root/packages')) {
    if (!file.contains('/lib/')) continue;
    final lines = File(file).readAsLinesSync();
    final rel = _rel(file, root);
    _checkSizes(rel, lines);
    _checkPackageImports(rel, lines);
  }
  warnings.forEach((w) => stdout.writeln('Warnung: $w'));
  errors.forEach((e) => stderr.writeln('Fehler:  $e'));
  stdout.writeln(
    '${errors.length} Fehler, ${warnings.length} Warnungen, '
    '$ignored Ausnahmen (arch-ignore).',
  );
  exit(errors.isEmpty ? 0 : 1);
}

Iterable<String> _dartFiles(String dir) {
  final d = Directory(dir);
  if (!d.existsSync()) return const [];
  return d
      .listSync(recursive: true)
      .whereType<File>()
      .map((f) => f.path)
      .where((p) => p.endsWith('.dart') && !p.contains('/.dart_tool/'))
      .where((p) => !p.endsWith('.g.dart') && !p.endsWith('.freezed.dart'));
}

String _rel(String path, String root) => path.substring(root.length + 1);

// ---------------------------------------------------------------- Größen --

void _checkSizes(String rel, List<String> lines) {
  if (lines.length > fileMaxLines) {
    errors.add('$rel hat ${lines.length} Zeilen (max. $fileMaxLines).');
  } else if (lines.length > fileWarnLines) {
    warnings.add('$rel hat ${lines.length} Zeilen (Ziel < $fileWarnLines).');
  }
  for (final fn in _functions(lines)) {
    final max = fn.name == 'build' ? buildMaxLines : functionMaxLines;
    if (fn.length > max) {
      errors.add(
        '$rel:${fn.line} ${fn.name}() hat ${fn.length} Zeilen '
        '(max. $max).',
      );
    }
  }
}

typedef _Fn = ({String name, int line, int length});

final _fnStart = RegExp(
  r'(\w+)\s*(<[^>]*>)?\([^;]*\)\s*(async\*?|sync\*)?\s*\{$',
);
const _keywords = {'if', 'for', 'while', 'switch', 'catch', 'on', 'return'};

/// Grobe Erkennung von Funktionskörpern über Klammerzählung. Reicht für
/// eine Längenprüfung, ist aber kein Parser.
List<_Fn> _functions(List<String> lines) {
  final result = <_Fn>[];
  for (var i = 0; i < lines.length; i++) {
    final text = _code(lines[i]).trim();
    final match = _fnStart.firstMatch(text);
    if (match == null || _keywords.contains(match.group(1))) continue;
    if (text.startsWith('}') || text.contains('=>')) continue;
    var depth = 0;
    for (var j = i; j < lines.length; j++) {
      final code = _code(lines[j]);
      depth += '{'.allMatches(code).length - '}'.allMatches(code).length;
      if (depth <= 0) {
        result.add((name: match.group(1)!, line: i + 1, length: j - i + 1));
        break;
      }
    }
  }
  return result;
}

/// Entfernt Kommentare und String-Inhalte, damit Klammern darin nicht zählen.
String _code(String line) => line
    .replaceAll(RegExp(r"'(?:[^'\\]|\\.)*'"), "''")
    .replaceAll(RegExp(r'"(?:[^"\\]|\\.)*"'), '""')
    .replaceAll(RegExp(r'//.*$'), '');

// --------------------------------------------------------------- Importe --

final _import = RegExp(r'''^\s*(?:import|export)\s+['"]([^'"]+)['"]''');

Iterable<(int, String)> _imports(List<String> lines) sync* {
  for (var i = 0; i < lines.length; i++) {
    final m = _import.firstMatch(lines[i]);
    if (m == null) continue;
    if (lines[i].contains('arch-ignore:')) {
      ignored++;
      continue;
    }
    yield (i + 1, m.group(1)!);
  }
}

void _checkPackageImports(String rel, List<String> lines) {
  for (final (line, target) in _imports(lines)) {
    if (target.startsWith('package:flutter') ||
        target.startsWith('package:wandoo/')) {
      errors.add(
        '$rel:$line Pakete dürfen weder Flutter noch die App '
        'importieren ($target).',
      );
    }
  }
}

void _checkAppImports(String rel, String file, List<String> lines, String lib) {
  final from = file.substring(lib.length + 1);
  for (final (line, target) in _imports(lines)) {
    final to = _resolve(target, file, lib);
    final problem = _violation(from, to, target);
    if (problem != null) errors.add('$rel:$line $problem ($target)');
  }
}

/// Pfad relativ zu app/lib, oder null bei fremden Paketen.
String? _resolve(String target, String file, String lib) {
  if (target.startsWith('package:wandoo/')) {
    return target.substring('package:wandoo/'.length);
  }
  if (target.contains(':')) return null;
  final abs = File(file).parent.uri.resolve(target).toFilePath();
  return abs.startsWith('$lib/') ? abs.substring(lib.length + 1) : null;
}

const _flutterOrInfra = [
  'package:flutter',
  'package:flutter_riverpod',
  'package:riverpod',
  'package:drift',
  'package:go_router',
];

String? _violation(String from, String? to, String raw) {
  final fromParts = from.split('/');
  final area = fromParts.first;
  final layer = area == 'features' && fromParts.length > 3 ? fromParts[2] : '';

  if (layer == 'domain' && _flutterOrInfra.any(raw.startsWith)) {
    return 'domain/ darf kein Flutter, Riverpod, Drift oder Router importieren';
  }
  if (to == null) return null;
  final toParts = to.split('/');
  final toArea = toParts.first;

  if ((area == 'core' || area == 'ui_kit') &&
      {'features', 'flows', 'bootstrap'}.contains(toArea)) {
    return '$area/ darf nichts aus $toArea/ importieren';
  }
  if (area == 'features' && {'flows', 'bootstrap'}.contains(toArea)) {
    return 'Features dürfen nichts aus $toArea/ importieren';
  }
  if (area == 'flows' && toArea == 'bootstrap') {
    return 'flows/ darf nichts aus bootstrap/ importieren';
  }
  if (toArea == 'features' && toParts.length > 1 && area != 'bootstrap') {
    final feature = toParts[1];
    final sameFeature = area == 'features' && fromParts[1] == feature;
    if (!sameFeature && to != 'features/$feature/$feature.dart') {
      return 'fremdes Feature nur über features/$feature/$feature.dart';
    }
    if (sameFeature) return _layerViolation(layer, toParts);
  }
  return null;
}

/// Erlaubte Richtungen innerhalb eines Features.
const _allowedLayers = {
  'domain': {'domain'},
  'data': {'domain', 'data'},
  'application': {'domain', 'application'},
  'presentation': {'domain', 'application', 'presentation'},
};

String? _layerViolation(String layer, List<String> toParts) {
  if (toParts.length < 4) return null; // öffentliche Datei oder README
  final allowed = _allowedLayers[layer];
  final target = toParts[2];
  if (allowed == null || allowed.contains(target)) return null;
  return '$layer/ darf nicht aus $target/ importieren';
}
