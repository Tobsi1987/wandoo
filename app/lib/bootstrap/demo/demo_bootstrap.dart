import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandoo/bootstrap/demo/demo_overrides.dart';
import 'package:wandoo/bootstrap/wandoo_app.dart';

/// Startet die App im Demo-Modus, zum Ausprobieren im Browser.
void demoBootstrap() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      overrides: demoOverrides(),
      child: const Directionality(
        textDirection: TextDirection.ltr,
        child: Banner(
          message: 'DEMO',
          location: BannerLocation.bottomStart,
          child: WandooApp(),
        ),
      ),
    ),
  );
}
