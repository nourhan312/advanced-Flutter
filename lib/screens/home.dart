import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notifications/cubit/notification_cubit.dart';
import '../constants/app_colors.dart';
import '../custom_elevated_button.dart';
import '../custom_rich_text.dart';
import '../services/notification_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedNotificationDay = '';
  int selectedDayOfTheWeek = 0;
  TimeOfDay selectedTime = TimeOfDay.now();
  bool isTimeSelected = false;

  // list of notification days
  final List<String> notificationDays = [
    'Mon',
    'Tue',
    'Wed',
    'Thur',
    'Fri',
    'Sat',
    'Sun',
  ];

  void triggerScheduleNotification() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Show Notification Every'),
        content: Wrap(
          spacing: 3.0,
          runSpacing: 8.0,
          children: notificationDays
              .asMap()
              .entries
              .map(
                (day) => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.secondaryColor,
                  ),
                  onPressed: () {
                    int index = day.key;
                    setState(() {
                      selectedNotificationDay = day.value;
                      selectedDayOfTheWeek =
                          index +
                          1; // Weekday is 1-indexed (Sunday is 1, Monday is 2, etc.)
                    });
                    Navigator.of(context).pop(); // Close day selection dialog
                    pickTime(); // Then, prompt for time selection
                  },
                  child: Text(
                    day.value,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  // Function to show a time picker dialog
  Future<TimeOfDay?> pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
        isTimeSelected = true;
      });
      // Create scheduled notification via Cubit
      context.read<NotificationCubit>().createScheduledNotification(
        time: selectedTime,
        dayOfWeek: selectedDayOfTheWeek,
      );
    }
    return null;
  }

  @override
  void initState() {
    super.initState();

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    // Set up listeners for various notification events
    AwesomeNotifications().setListeners(
      onNotificationCreatedMethod: (notification) async =>
          NotificationUtil.onNotificationCreatedMethod(notification, context),
      onActionReceivedMethod: NotificationUtil.onActionReceivedMethod,
      onDismissActionReceivedMethod: (ReceivedAction receivedAction) =>
          NotificationUtil.onDismissActionReceivedMethod(receivedAction),
      onNotificationDisplayedMethod:
          (ReceivedNotification receivedNotification) =>
              NotificationUtil.onNotificationDisplayedMethod(
                receivedNotification,
              ),
    );
  }

  @override
  void dispose() {
    // Dispose of AwesomeNotifications resources when the widget is removed
    AwesomeNotifications().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        title: const Wrap(spacing: 8),
        actions: [],
      ),
      body: BlocListener<NotificationCubit, NotificationState>(
        listener: (context, state) {
          if (state is NotificationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColor.primaryColor,
              ),
            );
          } else if (state is NotificationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Display selected day and time if a schedule is picked
                if (isTimeSelected) ...[
                  CustomRichText(
                    title: 'Selected Day: ',
                    content: selectedNotificationDay,
                  ),
                  const SizedBox(height: 10),
                  CustomRichText(
                    title: 'Selected Time: ',
                    content: selectedTime.format(context),
                  ),
                  const SizedBox(height: 10),
                ],
                const SizedBox(height: 20),
                // Buttons for various notification actions
                CustomElevatedButton(
                  function: () => context
                      .read<NotificationCubit>()
                      .createBasicNotification(),
                  title: 'Show Basic Notification',
                  icon: Icons.notifications,
                ),
                const SizedBox(height: 20),
                CustomElevatedButton(
                  function: triggerScheduleNotification,
                  title: 'Schedule Notification',
                  icon: Icons.schedule,
                ),
                const SizedBox(height: 20),
                CustomElevatedButton(
                  function: () => context
                      .read<NotificationCubit>()
                      .cancelAllScheduledNotifications(context),
                  title: 'Cancel All Scheduled Notifications',
                  icon: Icons.cancel,
                ),
                const SizedBox(height: 20),
                CustomElevatedButton(
                  function: () => context
                      .read<NotificationCubit>()
                      .createReplyNotification(),
                  title: 'Show Reply Notification',
                  icon: Icons.reply,
                ),
                const SizedBox(height: 20),
                CustomElevatedButton(
                  function: () => context
                      .read<NotificationCubit>()
                      .createMarkAsReadNotification(),
                  title: 'Show Mark as Read Notification',
                  icon: Icons.mark_email_read,
                ),
                const SizedBox(height: 20),
                CustomElevatedButton(
                  function: () => context
                      .read<NotificationCubit>()
                      .createReplyAndMarkAsReadNotification(),
                  title: 'Show Reply & Mark as Read Notification',
                  icon: Icons.reply_all,
                ),
                const SizedBox(height: 20),
                CustomElevatedButton(
                  function: () => context
                      .read<NotificationCubit>()
                      .createBigTextNotification(),
                  title: 'Show Big Text Notification',
                  icon: Icons.text_fields,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
