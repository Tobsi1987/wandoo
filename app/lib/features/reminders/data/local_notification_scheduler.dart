import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:wandoo/features/reminders/domain/reminder.dart';
import 'package:wandoo/features/reminders/domain/reminder_scheduler.dart';

/// Lokale Benachrichtigung, ganz ohne Server.
class LocalNotificationScheduler implements ReminderScheduler {
  LocalNotificationScheduler([FlutterLocalNotificationsPlugin? plugin])
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const _id = 1;
  static const _details = NotificationDetails(
    android: AndroidNotificationDetails(
      'reminders',
      'Erinnerungen',
      channelDescription: 'Sanfte Hinweise, wenn dein Wesen döst',
      importance: Importance.low,
      priority: Priority.low,
    ),
    iOS: DarwinNotificationDetails(),
  );

  final FlutterLocalNotificationsPlugin _plugin;
  Future<void>? _ready;

  Future<void> _init() async {
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestSoundPermission: false,
          requestBadgePermission: false,
        ),
      ),
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true);
  }

  @override
  Future<void> schedule(Reminder reminder) async {
    await (_ready ??= _init());
    await _plugin.zonedSchedule(
      id: _id,
      title: reminder.title,
      body: reminder.body,
      // Absoluter Zeitpunkt, daher reicht UTC ohne Zeitzonendatenbank.
      scheduledDate: tz.TZDateTime.from(reminder.at, tz.UTC),
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  @override
  Future<void> cancel() async {
    await (_ready ??= _init());
    await _plugin.cancel(id: _id);
  }
}
