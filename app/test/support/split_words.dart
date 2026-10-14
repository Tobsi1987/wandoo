import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Findet Wörter, die mitten im Wort auf die nächste Zeile umbrechen
/// ("Blume|nteppi|ch"). Trennstriche und Leerzeichen sind erlaubt.
List<String> splitWords(WidgetTester tester) {
  final found = <String>[];
  for (final element in find.byType(RichText).evaluate()) {
    final paragraph = element.renderObject;
    if (paragraph is! RenderParagraph || !paragraph.hasSize) continue;
    final text = paragraph.text.toPlainText(includeSemanticsLabels: false);
    double? lastTop;
    for (var i = 0; i < text.length; i++) {
      final boxes = paragraph.getBoxesForSelection(
        TextSelection(baseOffset: i, extentOffset: i + 1),
      );
      if (boxes.isEmpty) continue;
      final top = boxes.first.top;
      if (lastTop != null && top > lastTop + 1 && _inWord(text, i)) {
        found.add(text.replaceAll('\n', ' '));
        break;
      }
      lastTop = top;
    }
  }
  return found;
}

bool _inWord(String text, int i) =>
    i > 0 && _letter(text[i - 1]) && _letter(text[i]);

bool _letter(String c) => RegExp(r'[\p{L}\p{N}]', unicode: true).hasMatch(c);
