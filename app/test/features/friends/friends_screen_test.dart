import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wandoo/features/friends/data/in_memory_friends_repository.dart';
import 'package:wandoo/features/friends/friends.dart';

void main() {
  testWidgets('Freund per Code einfügen und in der Bestenliste sehen', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(800, 1600)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final repo = InMemoryFriendsRepository();
    final now = DateTime.now();
    final me = FriendCard(player: 'ich', week: weekOf(now), at: now);
    final friend = FriendCard(
      player: 'mia',
      week: weekOf(now),
      weekMeters: 2500,
      at: now,
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          friendsRepositoryProvider.overrideWithValue(repo),
          myCardProvider.overrideWithValue(me),
        ],
        child: const MaterialApp(home: FriendsScreen()),
      ),
    );
    await tester.tap(find.byKey(const Key('tab-friends')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('paste-friend')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('paste-friend')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('paste-code')),
      friend.encode(),
    );
    await tester.tap(find.byKey(const Key('paste-code-ok')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('friend-name')), 'Mia');
    await tester.tap(find.byKey(const Key('friend-name-ok')));
    await tester.pumpAndSettle();
    expect(repo.friends.single.name, 'Mia');
    await tester.tap(find.text('Bestenliste'));
    await tester.pumpAndSettle();
    expect(find.text('🥇'), findsOneWidget);
    expect(find.text('2,5 km'), findsOneWidget);
  });
}
