import 'package:admin/blocs/online_payment/online_payment_event.dart';
import 'package:admin/blocs/online_payment/online_payment_state.dart';
import 'package:admin/data/repo/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';




class OnlinePaymentBloc extends Bloc<OnlinePaymentEvent, OnlinePaymentState> {
  final OnlinePaymentRepository repository;

  OnlinePaymentBloc(this.repository) : super(OnlinePaymentInitial()) {
    on<FetchOnlinePayments>((event, emit) async {
      emit(OnlinePaymentLoading());
      try {
        final data = await repository.fetchOnlinePayments();
        emit(OnlinePaymentLoaded(data));
      } catch (e) {
        emit(OnlinePaymentError(e.toString()));
      }
    });
  }
}
