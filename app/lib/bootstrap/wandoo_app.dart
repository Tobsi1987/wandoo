import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/bootstrap/router.dart';
import 'package:wandoo/features/tracking/tracking.dart';
import 'package:wandoo/flows/process_walk/process_walk_provider.dart';
import 'package:wandoo/ui_kit/wandoo_theme.dart';

class WandooApp extends ConsumerWidget {
  const WandooApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Jeder neu abgelegte Gang (und offene Gänge beim Start) wird verarbeitet.
    ref.listen(pendingWalkCountProvider, (_, count) {
      if ((count.value ?? 0) > 0) {
        ref.read(pendingWalkProcessorProvider).processAll().ignore();
      }
    });
    return MaterialApp.router(
      title: 'Wandoo',
      theme: WandooTheme.light(),
      darkTheme: WandooTheme.dark(),
      routerConfig: appRouter,
    );
  }
}
