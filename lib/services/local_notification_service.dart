import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final LocalNotificationService _instance =
      LocalNotificationService._internal();
  factory LocalNotificationService() => _instance;
  LocalNotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Android can only control sound via *notification channels*.
  /// If you want users to change sound from the phone settings, don't hardcode
  /// a sound per-notification.
  static const String channelBasicId = 'basic_channel';
  static const String channelBasicName = 'Basic Notifications';

  static const String channelActionId = 'action_channel';
  static const String channelActionName = 'Action Notifications';

  Future<void> init() async {
    // Android initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.actionId == 'reply_action') {
          // Handle reply action
          // Note: on Android, this can carry a text input. On iOS it's limited.
          // ignore: avoid_print
          print('Reply received: ${response.input}');
        } else if (response.actionId == 'mark_as_read_action') {
          // ignore: avoid_print
          print('Mark as read clicked');
        }
      },
    );

    // Create Android channels (sound is controlled by the channel + user settings)
    final androidPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        channelBasicId,
        channelBasicName,
        description: 'This channel is for basic notification',
        importance: Importance.max,
      ),
    );

    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        channelActionId,
        channelActionName,
        description: 'Notifications with actions',
        importance: Importance.max,
      ),
    );

    // Android 13+ permission
    await androidPlugin?.requestNotificationsPermission();
  }

  Future<void> showBasicNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          channelBasicId,
          channelBasicName,
          channelDescription: 'This channel is for basic notification',
          importance: Importance.max,
          priority: Priority.high,
          // Expandable + scrollable for long text
          styleInformation: const BigTextStyleInformation(''),
        );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      // iOS sound can still be set here if you want; leaving null uses default.
      iOS: const DarwinNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
    );
  }

  /// Minimal scheduling without timezone setup: uses a simple timer.
  ///
  /// This is only for quick local testing.
  Future<void> showNotificationAfterDelay({
    required int id,
    required String title,
    required String body,
    required Duration delay,
  }) async {
    Timer(delay, () {
      // Fire-and-forget
      // ignore: discarded_futures
      showBasicNotification(id: id, title: title, body: body);
    });
  }

  /// Shows a notification optimized for very long content.
  ///
  /// On Android, this becomes expandable and allows scrolling.
  Future<void> showLongTextNotification({
    required int id,
    required String title,
    required String longBody,
    String? summaryText,
  }) async {
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          channelBasicId,
          channelBasicName,
          channelDescription: 'This channel is for basic notification',
          importance: Importance.max,
          priority: Priority.high,
          styleInformation: BigTextStyleInformation(
            longBody,
            contentTitle: title,
            summaryText: summaryText,
          ),
        );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      longBody,
      notificationDetails,
    );
  }

  Future<void> showNotificationWithActions({
    required int id,
    required String title,
    required String body,
  }) async {
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          channelActionId,
          channelActionName,
          channelDescription: 'Notifications with actions',
          importance: Importance.max,
          priority: Priority.high,
          actions: <AndroidNotificationAction>[
            AndroidNotificationAction(
              'reply_action',
              'Reply',
              inputs: <AndroidNotificationActionInput>[
                AndroidNotificationActionInput(label: 'Type your reply'),
              ],
            ),
            AndroidNotificationAction(
              'mark_as_read_action',
              'Mark as Read',
              showsUserInterface: false,
              cancelNotification: true,
            ),
          ],
          styleInformation: BigTextStyleInformation(
            body,
            contentTitle: title,
            summaryText: 'Tap to expand',
          ),
        );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
    );
  }

  Future<void> cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
