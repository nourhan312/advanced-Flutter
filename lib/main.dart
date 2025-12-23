import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'screens/home.dart';
import 'constants/app_colors.dart';
import 'package:notifications/cubit/notification_cubit.dart';
import 'package:notifications/services/notification_util.dart';
import 'package:notifications/services/local_notification_service.dart';
import 'package:notifications/services/fcm_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await LocalNotificationService().init();

  // FCM setup (foreground listeners + token)
  await FcmService(localNotifications: LocalNotificationService()).init();

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
