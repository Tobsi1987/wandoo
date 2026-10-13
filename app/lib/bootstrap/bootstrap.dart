import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/bootstrap/providers.dart';
import 'package:wandoo/bootstrap/wandoo_app.dart';

/// Startet die App mit allen verdrahteten Abhängigkeiten.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  final overrides = await appOverrides();
  runApp(ProviderScope(overrides: overrides, child: const WandooApp()));
}
