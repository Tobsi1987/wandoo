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
# Einmalig die Plattform-Ordner erzeugen:
cd app && flutter create --platforms=ios,android --org app.wandoo . && cd ..
# Optional: Pre-Commit-Hooks
lefthook install
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
