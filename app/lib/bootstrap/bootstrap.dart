import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/bootstrap/providers.dart';
import 'package:wandoo/bootstrap/wandoo_app.dart';

/// Startet die App mit allen verdrahteten Abhängigkeiten.
void bootstrap() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(overrides: appOverrides(), child: const WandooApp()));
}
