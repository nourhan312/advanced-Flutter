// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// import 'package:timezone/timezone.dart' as tz;
//
// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();
//   factory NotificationService() => _instance;
//   NotificationService._internal();
//
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   // إعداد الـ Notifications
//   Future<void> init() async {
//     // إعدادات Android - بدون تحديد icon محدد
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('app_icon');
//
//     // إعدادات iOS
//     const DarwinInitializationSettings initializationSettingsIOS =
//         DarwinInitializationSettings(
//           requestAlertPermission: true,
//           requestBadgePermission: true,
//           requestSoundPermission: true,
//         );
//
//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//           android: initializationSettingsAndroid,
//           iOS: initializationSettingsIOS,
//         );
//
//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) {
//         print('تم الضغط على الإشعار: ${response.payload}');
//       },
//     );
//
//     // طلب الأذونات لـ Android 13+
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >()
//         ?.requestNotificationsPermission();
//   }
//
//   // إرسال إشعار بسيط
//   Future<void> showSimpleNotification({
//     required String title,
//     required String body,
//   }) async {
//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//           'simple_channel',
//           'إشعارات بسيطة',
//           channelDescription: 'قناة للإشعارات البسيطة',
//           importance: Importance.high,
//           priority: Priority.high,
//         );
//
//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: DarwinNotificationDetails(),
//     );
//
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       body,
//       notificationDetails,
//     );
//   }
//
//   // إشعار موسع
//   Future<void> showBigPictureNotification() async {
//     const AndroidNotificationDetails
//     androidDetails = AndroidNotificationDetails(
//       'big_picture_channel',
//       'إشعارات موسعة',
//       channelDescription: 'إشعارات تحتوي على نص موسع',
//       importance: Importance.high,
//       priority: Priority.high,
//       styleInformation: BigTextStyleInformation(
//         'هذا نص طويل يظهر في الإشعار عندما يتم توسيعه. يمكنك كتابة أي محتوى تريده هنا وسوف يظهر بشكل جميل عند توسيع الإشعار!',
//         contentTitle: 'عنوان موسع',
//         summaryText: 'ملخص الإشعار',
//       ),
//     );
//
//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: DarwinNotificationDetails(),
//     );
//
//     await flutterLocalNotificationsPlugin.show(
//       1,
//       'إشعار موسع',
//       'اضغط للتوسيع',
//       notificationDetails,
//     );
//   }
//
//   // إشعار مع تقدم
//   Future<void> showProgressNotification() async {
//     for (int i = 0; i <= 100; i += 10) {
//       await Future.delayed(const Duration(milliseconds: 500));
//
//       final AndroidNotificationDetails androidDetails =
//           AndroidNotificationDetails(
//             'progress_channel',
//             'إشعارات التقدم',
//             channelDescription: 'إشعارات تظهر التقدم',
//             importance: Importance.low,
//             priority: Priority.low,
//             showProgress: true,
//             maxProgress: 100,
//             progress: i,
//             onlyAlertOnce: true,
//           );
//
//       final NotificationDetails notificationDetails = NotificationDetails(
//         android: androidDetails,
//       );
//
//       await flutterLocalNotificationsPlugin.show(
//         2,
//         'جاري التحميل...',
//         '$i%',
//         notificationDetails,
//       );
//     }
//   }
//
//   // إشعار مجدول
//   Future<void> scheduleNotification() async {
//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//           'scheduled_channel',
//           'إشعارات مجدولة',
//           channelDescription: 'إشعارات تأتي في وقت محدد',
//           importance: Importance.high,
//           priority: Priority.high,
//         );
//
//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: DarwinNotificationDetails(),
//     );
//
//     final scheduledTime = tz.TZDateTime.now(
//       tz.local,
//     ).add(const Duration(seconds: 5));
//
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       3,
//       'إشعار مجدول',
//       'هذا الإشعار ظهر بعد 5 ثواني!',
//       scheduledTime,
//       notificationDetails,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }
//
//   // إلغاء كل الإشعارات
//   Future<void> cancelAllNotifications() async {
//     await flutterLocalNotificationsPlugin.cancelAll();
//   }
// }
