import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Text, der nie mitten im Wort umbricht: Ist das längste Wort breiter
/// als der Platz, wird die Schrift so weit kleiner, dass es passt.
class WordSafeText extends StatelessWidget {
  const WordSafeText(
    this.text, {
    this.style,
    this.textAlign,
    this.maxLines,
    super.key,
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final base = DefaultTextStyle.of(context).style.merge(style);
      final scaler = MediaQuery.textScalerOf(context);
      var widest = 0.0;
      for (final word in text.split(RegExp(r'\s+'))) {
        final painter = TextPainter(
          text: TextSpan(text: word, style: base),
          textDirection: TextDirection.ltr,
          textScaler: scaler,
          maxLines: 1,
        )..layout();
        widest = math.max(widest, painter.width);
        painter.dispose();
      }
      final shrink = widest > box.maxWidth && widest > 0
          ? box.maxWidth / widest * 0.98
          : 1.0;
      final size = base.fontSize ?? 14;
      return Text(
        text,
        style: base.copyWith(fontSize: size * shrink),
        textAlign: textAlign,
        maxLines: maxLines,
      );
    },
  );
}
