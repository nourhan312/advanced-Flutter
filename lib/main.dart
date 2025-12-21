import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:notifications/screens/home.dart';
import 'constants/app_colors.dart';
import 'constants/app_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notifications/cubit/notification_cubit.dart';
import 'package:notifications/services/notification_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AwesomeNotifications().initialize(null, [
    // Notification channel for basic notifications
    NotificationChannel(
      channelKey: AppStrings.BASIC_CHANNEL_KEY,
      channelName: AppStrings.BASIC_CHANNEL_NAME,
      channelDescription: AppStrings.BASIC_CHANNEL_DESCRIPTION,
      defaultColor: AppColor.primaryColor,
      importance: NotificationImportance.High,
      defaultRingtoneType: DefaultRingtoneType.Notification,
    ),

    // Notification channel for scheduled notifications
    NotificationChannel(
      channelKey: AppStrings.SCHEDULE_CHANNEL_KEY,
      channelName: AppStrings.SCHEDULE_CHANNEL_NAME,
      channelDescription: AppStrings.SCHEDULE_CHANNEL_DESCRIPTION,
      defaultColor: AppColor.primaryColor,
      importance: NotificationImportance.High,
      defaultRingtoneType: DefaultRingtoneType.Notification,
    ),
  ], debug: false);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: BlocProvider(
        create: (context) => NotificationCubit(
          NotificationUtil(awesomeNotifications: AwesomeNotifications()),
        ),
        child: const HomePage(),
      ),
    );
  }
}
