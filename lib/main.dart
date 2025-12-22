import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens/home.dart';

// AWESOME NOTIFICATIONS (disabled)
// import 'package:awesome_notifications/awesome_notifications.dart';

import 'constants/app_colors.dart';
// import 'constants/app_constants.dart'; // (kept only for old awesome setup)
import 'package:notifications/cubit/notification_cubit.dart';
import 'package:notifications/services/notification_util.dart';
import 'package:notifications/services/local_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // AWESOME NOTIFICATIONS SETUP (disabled)
  // AwesomeNotifications().initialize(null, [
  //   NotificationChannel(
  //     channelKey: AppStrings.BASIC_CHANNEL_KEY,
  //     channelName: AppStrings.BASIC_CHANNEL_NAME,
  //     channelDescription: AppStrings.BASIC_CHANNEL_DESCRIPTION,
  //     defaultColor: AppColor.primaryColor,
  //     importance: NotificationImportance.High,
  //     defaultRingtoneType: DefaultRingtoneType.Notification,
  //   ),
  //   NotificationChannel(
  //     channelKey: AppStrings.SCHEDULE_CHANNEL_KEY,
  //     channelName: AppStrings.SCHEDULE_CHANNEL_NAME,
  //     channelDescription: AppStrings.SCHEDULE_CHANNEL_DESCRIPTION,
  //     defaultColor: AppColor.primaryColor,
  //     importance: NotificationImportance.High,
  //     defaultRingtoneType: DefaultRingtoneType.Notification,
  //   ),
  // ], debug: false);

  // Local notifications setup (flutter_local_notifications)
  await LocalNotificationService().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.primaryColor),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => NotificationCubit(
          NotificationUtil(local: LocalNotificationService()),
        ),
        child: const HomePage(),
      ),
    );
  }
}
