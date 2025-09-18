import 'package:admin/data/repo/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository repository;

  NotificationBloc(this.repository) : super(NotificationInitial()) {
    on<SendNotificationEvent>((event, emit) async {
      emit(NotificationLoading());
      try {
        final notification = await repository.sendNotification(
          cHeader: event.cHeader,
          cDescription: event.cDescription,
        );
        emit(NotificationSuccess(notification));
      } catch (e) {
        emit(NotificationFailure(e.toString()));
      }
    });
  }
}
