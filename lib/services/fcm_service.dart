import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'local_notification_service.dart';

class FcmService {
  FcmService({required this.localNotifications, FirebaseMessaging? messaging})
    : _messaging = messaging ?? FirebaseMessaging.instance;

  final LocalNotificationService localNotifications;
  final FirebaseMessaging _messaging;

  Future<void> init() async {
    // Request permission (iOS + Android 13+).
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    // For debug: get token.
    final token = await _messaging.getToken();
    if (token != null) {
      log('FCM token: $token');
    }

    // Token refresh
    _messaging.onTokenRefresh.listen((t) {
      log('FCM token refreshed: $t');
    });

    // Foreground messages: show our own local notification so sound/channel
    // settings are consistent.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await _showAsLocalNotification(message);
    });

    // If user taps a notification and opens the app.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('Notification opened: ${message.messageId}');
    });

    // Cold start: app launched by tapping notification.
    final initial = await _messaging.getInitialMessage();
    if (initial != null) {
      log('Initial message: ${initial.messageId}');
    }

    // Optional: useful when sending data-only messages.
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _showAsLocalNotification(RemoteMessage message) async {
    final notification = message.notification;

    // Use notification title/body if present, fall back to data.
    final title =
        notification?.title ?? (message.data['title']?.toString() ?? 'Message');
    final body = notification?.body ?? (message.data['body']?.toString() ?? '');

    // Use a stable-ish id.
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    await localNotifications.showBasicNotification(
      id: id,
      title: title,
      body: body,
    );
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log('Handling a background message: ${message.messageId}');
}
