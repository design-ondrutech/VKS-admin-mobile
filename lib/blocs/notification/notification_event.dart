import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class SendNotificationEvent extends NotificationEvent {
  final String cHeader;
  final String cDescription;

  const SendNotificationEvent({
    required this.cHeader,
    required this.cDescription,
  });

  @override
  List<Object?> get props => [cHeader, cDescription];
}
class FetchNotificationEvent extends NotificationEvent {
  const FetchNotificationEvent();

  @override
  List<Object?> get props => [];
}
