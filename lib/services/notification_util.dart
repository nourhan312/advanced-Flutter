// AWESOME NOTIFICATIONS (disabled)
// import 'dart:io';
// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
// import '../constants/app_constants.dart'; // not used in local implementation
import 'local_notification_service.dart';

// import '../main.dart';
// import '../screens/home.dart';

// =========================
// NotificationUtil (LOCAL)
// =========================
/// A small wrapper used by `NotificationCubit`.
///
/// The project originally used `awesome_notifications`. That code is kept below
/// as comments for reference, but the active implementation uses
/// `flutter_local_notifications`.
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

  /// Minimal scheduling for testing: show notification after [delay].
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

  Future<void> cancelAll(BuildContext context) async {
    await local.cancelAll();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cancelled all notifications'),
        backgroundColor: AppColor.primaryColor,
      ),
    );
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
