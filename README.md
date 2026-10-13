# Wandoo

Ein Wesen, das nur wächst, wenn du neue Wege gehst, und das so aussieht wie
die Orte, an denen du warst.

## Struktur

- `app/` – Flutter-App, nach Features geschnitten
- `packages/geo_engine/` – reines Dart: Map Matching, Neuheit, Umgebung
- `tool/` – Architektur-Prüfung, Feature-Generator, OSM-Aufbereitung
- `docs/` – Architektur und Entscheidungen (ADR)

Regeln: [docs/architecture.md](docs/architecture.md).

## Einrichten

```sh
flutter pub get
# Optional: Pre-Commit-Hooks
lefthook install
```

## Auf dem Handy testen (Android)

Nach jedem Merge baut der Workflow **Test-APK** eine installierbare APK
(GitHub > Actions > Test-APK > letzter Lauf > Artifacts). Sie ist mit dem
Debug-Schlüssel signiert und nur für Testgeräte gedacht.

1. ZIP auf dem Handy herunterladen und entpacken, `app-release.apk` öffnen,
   Installation aus dieser Quelle erlauben.
2. Beim ersten "Losgehen" Standort erlauben, Benachrichtigungen erlauben
   (für die Aufzeichnung im Hintergrund und die Erinnerung).
3. Widget: lange auf den Startbildschirm drücken > Widgets > Wandoo.

Kartendaten lädt die App beim ersten Gang einer Gegend live von
OpenStreetMap (Overpass) und speichert sie dann auf dem Gerät.

## Demo ohne Gerät

`app/lib/main_demo.dart` startet die App mit einer erfundenen Stadt und
simulierten Gängen im Zeitraffer, alles nur im Speicher (Verdrahtung in
`app/lib/bootstrap/demo/`). Läuft im Browser oder auf jedem Gerät:

```sh
cd app && flutter run -d chrome -t lib/main_demo.dart
# Statische Seite im Telefonrahmen (web/index.html):
flutter build web -t lib/main_demo.dart --no-web-resources-cdn --pwa-strategy=none
```

## Prüfen

```sh
dart format .
dart tool/check_architecture.dart
flutter analyze
(cd packages/geo_engine && dart test)
(cd app && flutter test)
```

Kartendaten © OpenStreetMap-Mitwirkende, ODbL.
