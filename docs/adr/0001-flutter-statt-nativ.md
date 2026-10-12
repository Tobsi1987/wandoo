# 0001: Flutter statt nativ

**Status:** vorgeschlagen (12.10.2026), noch nicht entschieden

## Kontext

Wandoo soll auf iOS und Android laufen, von einem kleinen Team gebaut und
mit geringen laufenden Kosten betrieben werden. Kritisch sind
Hintergrund-GPS und das Homescreen-Widget.

## Entscheidung

Flutter mit Dart als Default. Plattformnah bleiben das Homescreen-Widget
(SwiftUI/WidgetKit, Kotlin/Glance) und die Hintergrund-Ortung über ein
Plattform-Paket hinter der Schnittstelle `LocationSource`.

## Folgen

- Eine Codebasis für beide Plattformen, die Kernlogik in `geo_engine`
  ist reines Dart und plattformunabhängig testbar.
- Widget-Code muss zweimal nativ geschrieben werden.
- Fällt die Wahl doch auf nativ, bleiben Modulschnitt und Regeln gleich;
  `geo_engine` müsste dann portiert werden.
