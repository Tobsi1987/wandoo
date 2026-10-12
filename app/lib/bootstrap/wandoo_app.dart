import 'package:flutter/material.dart';
import 'package:wandoo/bootstrap/router.dart';
import 'package:wandoo/ui_kit/wandoo_theme.dart';

class WandooApp extends StatelessWidget {
  const WandooApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Wandoo',
      theme: WandooTheme.light(),
      darkTheme: WandooTheme.dark(),
      routerConfig: appRouter,
    );
  }
}
