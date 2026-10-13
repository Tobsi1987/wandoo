# home_widget

**Zweck:** Bringt das Wesen auf den Homescreen (nativer Widget-Code liegt in app/ios und app/android).

**Bekommt:** das aktuelle Wesen aus `creature` (angestoßen in `bootstrap/wandoo_app.dart`).

**Liefert:** `SyncHomeWidget` übersetzt das Wesen in vier Texte
(`face`, `stage`, `detail`, `mood`, siehe `WidgetSnapshot`) und übergibt sie
per Paket `home_widget` an das native Widget.

- Android: `android/app/src/main/kotlin/app/wandoo/wandoo/CreatureWidgetProvider.kt`,
  Layout `res/layout/creature_widget.xml`.
- iOS: noch offen. Braucht eine WidgetKit-Extension `CreatureWidget` mit
  App Group, die in Xcode angelegt wird; die Dart-Seite ruft sie schon auf.
