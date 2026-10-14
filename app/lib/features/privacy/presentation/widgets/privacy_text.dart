import 'package:flutter/material.dart';

/// Die Datenschutzerklärung in einfachen Worten, Abschnitt für Abschnitt.
class PrivacyText extends StatelessWidget {
  const PrivacyText({super.key});

  static const sections = [
    (
      'Was auf dem Handy bleibt',
      'Deine Gänge, die Straßen, die du kennst, dein Wesen, das Tagebuch, '
          'die Schätze und alle Einstellungen speichert Wandoo nur auf diesem '
          'Handy. Es gibt kein Konto, keinen Namen, keine Werbung und keine '
          'Auswertung, und Wandoo hat keinen eigenen Server.',
    ),
    (
      'Standort',
      'Den Standort nutzt Wandoo nur, während ein Gang läuft: vom Druck auf '
          '„Losgehen“ bis zum Ende. Dafür fragt das Handy einmal um '
          'Erlaubnis.',
    ),
    (
      'Straßendaten (nötig)',
      'Damit Wandoo neue Straßen erkennt, lädt es die Straßen der Gegend '
          'von OpenStreetMap über overpass-api.de (FOSSGIS e.V.). Dabei '
          'gehen ein Kartenstück von etwa 5 mal 5 km und die '
          'Internetadresse des Handys an diesen Dienst. Einmal geladene '
          'Stücke bleiben auf dem Handy.',
    ),
    (
      'Wetter (nur wenn eingeschaltet)',
      'Open-Meteo (open-meteo.com) bekommt den Ort auf etwa 10 km gerundet '
          'und die Internetadresse des Handys.',
    ),
    (
      'Kartenbild (nur wenn eingeschaltet)',
      'Die OpenStreetMap Foundation (tile.openstreetmap.org) bekommt den '
          'sichtbaren Kartenausschnitt und die Internetadresse des Handys.',
    ),
    (
      'Teilen und Erinnerungen',
      'Ein Bild verlässt das Handy nur, wenn du selbst auf Teilen drückst. '
          'Erinnerungen plant das Handy selbst, ohne Server.',
    ),
    (
      'Sicherung des Handys',
      'Ist am Handy eine Datensicherung eingeschaltet, kann das Handy die '
          'Daten von Wandoo in diese Sicherung aufnehmen.',
    ),
    (
      'Löschen',
      'Mit „Alle Daten löschen“ unter Datenschutz ist sofort alles weg. '
          'Wer die App vom Handy löscht, löscht damit auch alle Daten.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (title, body) in sections) ...[
          Text(title, style: text.titleSmall),
          const SizedBox(height: 4),
          Text(body, style: text.bodyMedium),
          const SizedBox(height: 14),
        ],
      ],
    );
  }
}
