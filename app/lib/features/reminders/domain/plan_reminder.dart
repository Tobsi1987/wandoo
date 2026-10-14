import 'package:wandoo/features/reminders/domain/reminder.dart';

/// Plant sanfte Erinnerungen nach dem letzten Gang: an den nächsten drei
/// Tagen höchstens eine am Tag, immer am Nachmittag, nie abends. Danach ist
/// Ruhe. Keine Strafe, kein Druck.
class PlanReminder {
  const PlanReminder({this.days = 3, this.hour = 16});

  /// An so vielen Tagen nach dem letzten Gang wird erinnert.
  final int days;

  /// Uhrzeit der Erinnerung (nach der Schule, vor dem Abend).
  final int hour;

  /// Erinnerungen nach dem Gang am [lastWalkAt]; [name] ist der Name des
  /// Wesens, null für ein Ei. Ohne Gang keine Erinnerung.
  ///
  /// [hungryAt] ist, wann der Hungerbalken leer ist: Ab diesem Tag werden
  /// die Erinnerungen dringlicher, zwei Tage lang, bis das Wesen auszieht.
  List<Reminder> call(
    DateTime? lastWalkAt, {
    String? name,
    DateTime? hungryAt,
  }) {
    if (lastWalkAt == null) return const [];
    final day = lastWalkAt.toLocal();
    final urgent = name == null || hungryAt == null
        ? const <Reminder>[]
        : _urgent(hungryAt.toLocal(), name);
    final firstUrgent = urgent.firstOrNull?.at;
    return [
        for (var i = 1; i <= days; i++)
          _text(
            DateTime(day.year, day.month, day.day + i, hour),
            name,
            (i - 1) % 3,
          ),
      ].where((r) => firstUrgent == null || r.at.isBefore(firstUrgent)).toList()
      ..addAll(urgent);
  }

  /// Am Tag, an dem der Bauch leer ist, und am Tag danach.
  List<Reminder> _urgent(DateTime empty, String name) {
    final start = empty.hour < hour ? empty.day : empty.day + 1;
    DateTime at(int plus) =>
        DateTime(empty.year, empty.month, start + plus, hour);
    return [
      Reminder(
        at: at(0),
        title: '$name hat Hunger',
        body:
            'Der Bauch von $name ist leer. Ein Spaziergang macht wieder satt.',
      ),
      Reminder(
        at: at(1),
        title: '$name ist ganz traurig',
        body:
            '$name hat schon lange nichts gegessen und muss sich sonst '
            'selbst Futter suchen. Geht heute zusammen raus!',
      ),
    ];
  }

  static Reminder _text(DateTime at, String? name, int which) {
    final (title, body) = name == null
        ? switch (which) {
            0 => (
              'Dein Ei ist ganz warm',
              'Nimm es mit nach draußen, vielleicht schlüpft bald etwas.',
            ),
            1 => (
              'Im Ei rumpelt es',
              'Ein kleiner Spaziergang hilft deinem Ei beim Schlüpfen.',
            ),
            _ => (
              'Dein Ei wartet auf dich',
              'Draußen an der frischen Luft wird es am schnellsten warm.',
            ),
          }
        : switch (which) {
            0 => (
              '$name möchte raus',
              'Hast du Lust auf einen kleinen Spaziergang? $name kommt gern '
                  'mit.',
            ),
            1 => (
              '$name ist neugierig',
              'Gibt es eine Straße, die ihr noch nie gegangen seid? $name '
                  'würde sie gern entdecken.',
            ),
            _ => (
              '$name denkt an dich',
              'Schon ein kurzer Gang macht $name eine große Freude.',
            ),
          };
    return Reminder(at: at, title: title, body: body);
  }
}
