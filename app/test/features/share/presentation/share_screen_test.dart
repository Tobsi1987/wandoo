import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/creature/creature.dart';
import 'package:wandoo/features/creature/data/in_memory_creature_repository.dart';
import 'package:wandoo/features/share/share.dart';

class _RecordingSharer implements ImageSharer {
  final shared = <(Uint8List, String)>[];

  @override
  Future<void> sharePng(Uint8List png, {required String text}) async =>
      shared.add((png, text));
}

void main() {
  testWidgets('teilt die Vorschau als PNG mit Begleittext', (tester) async {
    final sharer = _RecordingSharer();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          creatureRepositoryProvider.overrideWithValue(
            InMemoryCreatureRepository(),
          ),
          imageSharerProvider.overrideWithValue(sharer),
        ],
        child: const MaterialApp(home: ShareScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Ei'), findsOneWidget);

    await tester.runAsync(() async {
      await tester.tap(find.text('Teilen'));
      await Future<void>.delayed(const Duration(milliseconds: 200));
    });
    await tester.pump();

    expect(sharer.shared, hasLength(1));
    final (png, text) = sharer.shared.single;
    expect(png.sublist(1, 4), 'PNG'.codeUnits);
    expect(text, contains('Ei'));
  });
}
