import 'local_notification_service.dart';

class NotificationUtil {
  final LocalNotificationService local;

  NotificationUtil({required this.local});

  Future<void> createBasicNotification({
    required int id,
    required String channelKey,
    required String title,
    required String body,
  }) async {
    await local.showBasicNotification(id: id, title: title, body: body);
  }

  Future<void> createScheduledNotificationAfter({
    required int id,
    required String title,
    required String body,
    required Duration delay,
  }) async {
    await local.showNotificationAfterDelay(
      id: id,
      title: title,
      body: body,
      delay: delay,
    );
  }

  Future<void> createNotificationWithReplyAndMarkAsRead({
    required int id,
    required String title,
    required String body,
  }) async {
    await local.showNotificationWithActions(id: id, title: title, body: body);
  }

  Future<void> cancelAll() async {
    await local.cancelAll();
  }

  Future<void> createLongTextNotification({
    required int id,
    required String title,
    required String longBody,
  }) async {
    await local.showLongTextNotification(
      id: id,
      title: title,
      longBody: longBody,
      summaryText: 'Tap to expand',
    );
  }
}
