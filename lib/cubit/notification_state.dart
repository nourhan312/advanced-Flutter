part of 'notification_cubit.dart';

@immutable
abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationSuccess extends NotificationState {
  final String message;
  NotificationSuccess(this.message);
}

class NotificationError extends NotificationState {
  final String error;
  NotificationError(this.error);
}
