import 'package:admin/data/models/notification_model.dart';


abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationSuccess extends NotificationState {
  final NotificationModel notification;

  NotificationSuccess(this.notification);
}

class NotificationFailure extends NotificationState {
  final String error;

  NotificationFailure(this.error);
}
