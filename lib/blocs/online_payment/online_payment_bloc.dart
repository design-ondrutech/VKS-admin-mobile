import 'package:admin/data/repo/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin/blocs/online_payment/online_payment_event.dart';
import 'package:admin/blocs/online_payment/online_payment_state.dart';
import 'package:admin/data/models/online_payment.dart';

class OnlinePaymentBloc extends Bloc<FetchOnlinePayments, OnlinePaymentState> {
  final OnlinePaymentRepository repository;
  int currentPage = 1;
  bool isFetching = false;
  List<OnlinePayment> allPayments = [];

  OnlinePaymentBloc(this.repository) : super(OnlinePaymentInitial()) {
    on<FetchOnlinePayments>((event, emit) async {
      if (isFetching) return; // prevent duplicate calls
      isFetching = true;

      try {
        if (event.page == 1) {
          emit(OnlinePaymentLoading());
          allPayments.clear();
        }

        final response = await repository.fetchOnlinePayments(); // update repository to accept page/limit if needed
        currentPage = response.currentPage;
        allPayments.addAll(response.data);

        emit(OnlinePaymentLoaded(
            response: OnlinePaymentResponse(
                data: allPayments,
                limit: response.limit,
                totalCount: response.totalCount,
                totalPages: response.totalPages,
                currentPage: response.currentPage)));
      } catch (e) {
        emit(OnlinePaymentError(message: e.toString()));
      } finally {
        isFetching = false;
      }
    });
  }
}
