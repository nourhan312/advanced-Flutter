import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import '../constants/app_constants.dart';
import '../services/create_uid.dart';
import '../services/notification_util.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationUtil notificationUtil;

  NotificationCubit(this.notificationUtil) : super(NotificationInitial());

  void createBasicNotification() async {
    try {
      emit(NotificationLoading());
      await notificationUtil.createBasicNotification(
        id: createUniqueId(),
        channelKey: AppStrings.BASIC_CHANNEL_KEY,
        title:
            '${Emojis.clothing_backpack + Emojis.transport_air_airplane} Network Call',
        body:
            'Lorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia,molestiae quas vel sint commodi repudiandae consequuntur',
        bigPicture: 'asset://assets/image.png',
      );
      emit(NotificationSuccess('Basic Notification Created'));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  void createScheduledNotification({
    required TimeOfDay time,
    required int dayOfWeek,
  }) async {
    try {
      emit(NotificationLoading());
      await notificationUtil.createScheduledNotification(
        id: createUniqueId(),
        channelKey: AppStrings.SCHEDULE_CHANNEL_KEY,
        title: '${Emojis.time_alarm_clock} Check your rocket!',
        body:
            'Lorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia,molestiae quas vel sint commodi repudiandae consequuntur',
        layout: NotificationLayout.Default,
        notificationCalendar: NotificationCalendar(
          hour: time.hour,
          minute: time.minute,
          weekday: dayOfWeek,
        ),
      );
      emit(NotificationSuccess('Scheduled Notification Created'));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  void cancelAllScheduledNotifications(BuildContext context) {
    try {
      emit(NotificationLoading());
      notificationUtil.cancelAllScheduledNotifications(context: context);
      emit(NotificationSuccess('All Scheduled Notifications Cancelled'));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  void createReplyNotification() async {
    try {
      emit(NotificationLoading());
      await notificationUtil.createNotificationWithReply(
        id: createUniqueId(),
        channelKey: AppStrings.BASIC_CHANNEL_KEY,
        title: 'Reply Notification',
        body: 'This notification has a reply button.',
        bigPicture: 'asset://assets/image.png',
      );
      emit(NotificationSuccess('Reply Notification Created'));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  void createMarkAsReadNotification() async {
    try {
      emit(NotificationLoading());
      await notificationUtil.createNotificationWithMarkAsRead(
        id: createUniqueId(),
        channelKey: AppStrings.BASIC_CHANNEL_KEY,
        title: 'Mark as Read Notification',
        body: 'This notification has a Mark as Read button.',
        bigPicture: 'asset://assets/image.png',
      );
      emit(NotificationSuccess('Mark as Read Notification Created'));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  void createReplyAndMarkAsReadNotification() async {
    try {
      emit(NotificationLoading());
      await notificationUtil.createNotificationWithReplyAndMarkAsRead(
        id: createUniqueId(),
        channelKey: AppStrings.BASIC_CHANNEL_KEY,
        title: 'Reply & Mark as Read',
        body: 'This notification has both Reply and Mark as Read buttons.',
        bigPicture: 'asset://assets/image.png',
      );
      emit(NotificationSuccess('Reply & Mark as Read Notification Created'));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  void createBigTextNotification() async {
    try {
      emit(NotificationLoading());
      await notificationUtil.createBigTextNotification(
        id: createUniqueId(),
        channelKey: AppStrings.BASIC_CHANNEL_KEY,
        title: 'Big Text Notification',
        body:
            'This is a notification with a lot of text. It can expand to show more content when the user drags it down. This is useful for showing longer messages or descriptions without opening the app.',
        bigPicture: 'asset://assets/image.png',
      );
      emit(NotificationSuccess('Big Text Notification Created'));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }
}
