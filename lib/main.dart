import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';
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
      home: BlocProvider<NotificationCubit>(
        create: (_) => NotificationCubit(
          NotificationUtil(local: LocalNotificationService()),
        ),
        child: const HomePage(),
      ),
    );
  }
}
