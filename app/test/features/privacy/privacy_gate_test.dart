import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/privacy/data/in_memory_privacy_repository.dart';
import 'package:wandoo/features/privacy/privacy.dart';

import '../../support/real_fonts.dart';
import '../../support/split_words.dart';

class _Wiper implements DataWiper {
  bool wiped = false;

  @override
  Future<void> wipeAll() async => wiped = true;
}

Widget _app(InMemoryPrivacyRepository repo, Widget home, [DataWiper? w]) =>
    ProviderScope(
      overrides: [
        privacyRepositoryProvider.overrideWithValue(repo),
        if (w != null) dataWiperProvider.overrideWithValue(w),
      ],
      child: MaterialApp(
        builder: (context, child) => PrivacyGate(child: child!),
        home: home,
      ),
    );

void main() {
  testWidgets('erst der Hinweis, dann die App', (tester) async {
    final fonts = await tester.runAsync(loadRoboto);
    expect(fonts, isTrue);
    tester.view
      ..physicalSize = const Size(340, 740)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final repo = InMemoryPrivacyRepository();
    await tester.pumpWidget(_app(repo, const Text('App')));
    await tester.pumpAndSettle();
    expect(find.text('App'), findsNothing);
    expect(splitWords(tester), isEmpty);
    await tester.tap(find.byKey(const Key('privacy-weather')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('privacy-ok')));
    await tester.tap(find.byKey(const Key('privacy-ok')));
    await tester.pumpAndSettle();
    expect(find.text('App'), findsOneWidget);
    expect(repo.current, const PrivacyChoices(informed: true, weather: true));
  });

  testWidgets('Alle Daten löschen fragt nach und löscht', (tester) async {
    final repo = InMemoryPrivacyRepository(
      const PrivacyChoices(informed: true),
    );
    final wiper = _Wiper();
    await tester.pumpWidget(_app(repo, const PrivacyScreen(), wiper));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.byKey(const Key('privacy-wipe')), 300);
    await tester.tap(find.byKey(const Key('privacy-wipe')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('privacy-wipe-yes')));
    await tester.pumpAndSettle();
    expect(wiper.wiped, isTrue);
  });
}
