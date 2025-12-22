import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final LocalNotificationService _instance =
      LocalNotificationService._internal();
  factory LocalNotificationService() => _instance;
  LocalNotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String channelBasicId = 'basic_channel';
  static const String channelBasicName = 'Basic Notifications';

  static const String channelLongTextId = 'long_text_channel';
  static const String channelLongTextName = 'Long Text Notifications';

  static const String channelActionId = 'action_channel';
  static const String channelActionName = 'Action Notifications';

  // Actions
  static const String actionReplyId = 'reply_action';
  static const String actionMarkAsReadId = 'mark_as_read_action';

  // Audio
  static const String androidSoundResourceName = 'sound'; // sound.wav
  static const String iosSoundFileName = 'notification_sound.aiff';

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

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
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    final androidPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    final sound = const RawResourceAndroidNotificationSound(
      androidSoundResourceName,
    );

    await androidPlugin?.createNotificationChannel(
      AndroidNotificationChannel(
        channelBasicId,
        channelBasicName,
        description: 'Basic local notifications with custom sound',
        importance: Importance.max,
        sound: sound,
        playSound: true,
      ),
    );

    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        channelLongTextId,
        channelLongTextName,
        description: 'Expandable notifications (default sound)',
        importance: Importance.max,
        playSound: true,
      ),
    );

    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        channelActionId,
        channelActionName,
        description: 'Notifications with actions (default sound)',
        importance: Importance.max,
        playSound: true,
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
    final androidDetails = AndroidNotificationDetails(
      channelBasicId,
      channelBasicName,
      channelDescription: 'Basic local notifications with custom sound',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound(
        androidSoundResourceName,
      ),
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(sound: iosSoundFileName),
    );

    await flutterLocalNotificationsPlugin.show(id, title, body, details);
  }

  Future<void> showNotificationAfterDelay({
    required int id,
    required String title,
    required String body,
    required Duration delay,
  }) async {
    Timer(delay, () {
      showBasicNotification(id: id, title: title, body: body);
    });
  }

  Future<void> showLongTextNotification({
    required int id,
    required String title,
    required String longBody,
    String? summaryText,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      channelLongTextId,
      channelLongTextName,
      channelDescription: 'Expandable notifications',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(
        longBody,
        contentTitle: title,
        summaryText: summaryText,
      ),
      playSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.show(id, title, longBody, details);
  }

  // ACTIONS (default sound)
  Future<void> showNotificationWithActions({
    required int id,
    required String title,
    required String body,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      channelActionId,
      channelActionName,
      channelDescription: 'Notifications with actions',
      importance: Importance.max,
      priority: Priority.high,
      actions: const [
        AndroidNotificationAction(
          actionReplyId,
          'Reply',
          inputs: [
            AndroidNotificationActionInput(
              label: 'Type your reply…',
              allowFreeFormInput: true,
            ),
          ],
        ),
        AndroidNotificationAction(
          actionMarkAsReadId,
          'Mark as read',
          showsUserInterface: false,
          cancelNotification: true,
        ),
      ],
      playSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.show(id, title, body, details);
  }

  Future<void> cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  void _onNotificationResponse(NotificationResponse response) {
    if (response.actionId == actionReplyId) {
      final replyText = response.input;
      return;
    }

    if (response.actionId == actionMarkAsReadId) {
      return;
    }
  }
}
