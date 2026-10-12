// Legt ein neues Feature mit der Standardstruktur an. Aufruf:
//
//   dart tool/new_feature.dart <name_in_snake_case> "<Zweck in einem Satz>"
import 'dart:io';

void main(List<String> args) {
  if (args.isEmpty || !RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(args.first)) {
    stderr.writeln(
      'Aufruf: dart tool/new_feature.dart <snake_case_name> '
      '"<Zweck>"',
    );
    exit(64);
  }
  final name = args.first;
  final purpose = args.length > 1 ? args[1] : 'TODO: Zweck in einem Satz.';
  final dir = Directory('app/lib/features/$name');
  if (dir.existsSync()) {
    stderr.writeln('${dir.path} existiert schon.');
    exit(1);
  }
  for (final layer in ['domain', 'data', 'application', 'presentation']) {
    File('${dir.path}/$layer/.gitkeep').createSync(recursive: true);
  }
  File('app/test/features/$name/.gitkeep').createSync(recursive: true);
  File('${dir.path}/$name.dart').writeAsStringSync('''
/// Öffentliche Schnittstelle von `$name`.
///
/// Nur exportieren, was andere Module wirklich brauchen.
library;
''');
  File('${dir.path}/README.md').writeAsStringSync('''
# $name

**Zweck:** $purpose

**Bekommt:** TODO

**Liefert:** TODO
''');
  stdout.writeln('Feature $name angelegt unter ${dir.path}');
}
