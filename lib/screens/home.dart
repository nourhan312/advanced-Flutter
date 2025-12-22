import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/notification_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationCubit, NotificationState>(
      listener: (context, state) {
        if (state is NotificationSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
        if (state is NotificationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Local Notifications Test')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () => context
                      .read<NotificationCubit>()
                      .createBasicNotification(),
                  child: const Text('Show basic notification'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => context
                      .read<NotificationCubit>()
                      .createReplyAndMarkAsReadNotification(),
                  child: const Text('Show notification with actions (Android)'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => context
                      .read<NotificationCubit>()
                      .scheduleNotificationIn5Seconds(),
                  child: const Text('Schedule notification in 5 seconds'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => context
                      .read<NotificationCubit>()
                      .showScrollableLongContentNotification(),
                  child: const Text(
                    'Show scrollable long-content notification',
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => context
                      .read<NotificationCubit>()
                      .cancelAllNotifications(context),
                  child: const Text('Cancel all notifications'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
