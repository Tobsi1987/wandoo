import 'package:flutter/material.dart';
import 'package:wandoo/features/friends/presentation/widgets/friends_view.dart';
import 'package:wandoo/features/friends/presentation/widgets/leaderboard_view.dart';

/// Bestenliste und Freunde, ganz ohne Server und Konto.
class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  static const path = '/freunde';

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 2,
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Freunde'),
        bottom: const TabBar(
          tabs: [
            Tab(text: 'Bestenliste'),
            Tab(key: Key('tab-friends'), text: 'Freunde'),
          ],
        ),
      ),
      body: const TabBarView(children: [LeaderboardView(), FriendsView()]),
    ),
  );
}
