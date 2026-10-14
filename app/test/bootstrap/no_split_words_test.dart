import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/bootstrap/demo/demo_overrides.dart';
import 'package:wandoo/bootstrap/demo/demo_params.dart';
import 'package:wandoo/bootstrap/router.dart';
import 'package:wandoo/bootstrap/wandoo_app.dart';
import 'package:wandoo/features/den/den.dart';

import '../support/real_fonts.dart';
import '../support/split_words.dart';

// Geht durch alle Seiten der App auf einem schmalen Handy mit etwas
// größerer Schrift und prüft, dass kein Wort mitten drin umbricht.

const _pages = [
  '/',
  '/abenteuer',
  '/album',
  '/baden',
  '/erfolge',
  '/hoehle',
  '/karte',
  '/puzzle',
  '/schatzkiste',
  '/tagebuch',
  '/teilen',
];

void main() {
  setUp(() {
    demoParams = {
      'wesen': 'blaetterdrache',
      'uhr': '12',
      'wetter': 'regen',
      'matsch': '3',
      'spur': 'wald2',
    };
  });

  testWidgets('kein Wort bricht mitten drin um', (tester) async {
    final fonts = await tester.runAsync(loadRoboto);
    expect(fonts, isTrue, reason: 'Roboto aus dem Flutter-SDK fehlt');
    tester.view
      ..physicalSize = const Size(340, 740)
      ..devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.3;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(
      ProviderScope(overrides: demoOverrides(), child: const WandooApp()),
    );
    await _settle(tester);
    final broken = <String>[];
    for (final page in _pages) {
      appRouter.go(page);
      await _settle(tester);
      broken.addAll(splitWords(tester).map((t) => '$page: $t'));
    }
    appRouter.go('/hoehle');
    await _settle(tester);
    for (final spot in Spot.values) {
      final box = tester.getRect(find.byKey(Key('spot-${spot.name}')));
      await tester.tapAt(box.center + Offset(0, box.height * 0.3));
      await _settle(tester);
      broken.addAll(splitWords(tester).map((t) => 'Zuhause ${spot.name}: $t'));
      Navigator.of(tester.element(find.byType(BottomSheet))).pop();
      await _settle(tester);
    }
    expect(broken, isEmpty);
  });
}

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}
