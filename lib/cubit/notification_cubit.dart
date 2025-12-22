import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../services/create_uid.dart';
import '../services/notification_util.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationUtil notificationUtil;

  NotificationCubit(this.notificationUtil) : super(NotificationInitial());

  Future<void> createBasicNotification() async {
    try {
      emit(NotificationLoading());
      await notificationUtil.createBasicNotification(
        id: createUniqueId(),
        channelKey: 'basic_channel',
        title: 'Local Notification',
        body:
            'This is a basic local notification (flutter_local_notifications).',
      );
      emit(NotificationSuccess('Basic Local Notification Created'));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> scheduleNotificationIn5Seconds() async {
    try {
      emit(NotificationLoading());
      await notificationUtil.createScheduledNotificationAfter(
        id: createUniqueId(),
        title: 'Scheduled (5s)',
        body: 'This notification was scheduled with a short delay.',
        delay: const Duration(seconds: 5),
      );
      emit(NotificationSuccess('Scheduled notification in 5 seconds'));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> createReplyAndMarkAsReadNotification() async {
    try {
      emit(NotificationLoading());

      final longBody = List.generate(
        18,
        (i) =>
            'Message line ${i + 1}: Tap expand to read more. This is a long body to demonstrate scrolling inside the notification.',
      ).join('\n');

      await notificationUtil.createNotificationWithReplyAndMarkAsRead(
        id: createUniqueId(),
        title: 'Actions (Expandable)',
        body: longBody,
      );
      emit(NotificationSuccess('Expandable Action Notification Created'));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> cancelAllNotifications(BuildContext context) async {
    try {
      emit(NotificationLoading());
      await notificationUtil.cancelAll();
      emit(NotificationSuccess('Cancelled all notifications'));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> showScrollableLongContentNotification() async {
    try {
      emit(NotificationLoading());

      final longText = List.generate(
        25,
        (i) =>
            'Line ${i + 1}: This is long notification content so you can scroll after expanding. '
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      ).join('\n\n');

      await notificationUtil.createLongTextNotification(
        id: createUniqueId(),
        title: 'Scrollable notification',
        longBody: longText,
      );

      emit(NotificationSuccess('Scrollable/expandable notification created'));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }
}
