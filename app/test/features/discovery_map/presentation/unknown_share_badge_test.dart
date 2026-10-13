import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/discovery_map/presentation/widgets/unknown_share_badge.dart';

void main() {
  Future<void> pump(WidgetTester tester, int percent) =>
      tester.pumpWidget(MaterialApp(home: UnknownShareBadge(percent: percent)));

  testWidgets('zeigt den unbekannten Anteil', (tester) async {
    await pump(tester, 23);
    expect(find.text('noch 23 % unbekannt'), findsOneWidget);
  });

  testWidgets('feiert, wenn alles entdeckt ist', (tester) async {
    await pump(tester, 0);
    expect(find.text('Alles entdeckt!'), findsOneWidget);
  });
}
