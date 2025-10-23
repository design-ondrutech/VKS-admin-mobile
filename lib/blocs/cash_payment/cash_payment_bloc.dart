import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin/blocs/cash_payment/cash_payment_event.dart';
import 'package:admin/blocs/cash_payment/cash_payment_state.dart';
import 'package:admin/data/repo/auth_repository.dart';

class CashPaymentBloc extends Bloc<FetchCashPayments, CashPaymentState> {
  final CashPaymentRepository repository;
  bool isFetching = false;

  CashPaymentBloc(this.repository) : super(CashPaymentInitial()) {
    on<FetchCashPayments>((event, emit) async {
      if (isFetching) return;
      isFetching = true;

      try {
        emit(CashPaymentLoading());

        final response = await repository.fetchCashPayments(
          page: event.page,
          limit: event.limit,
        );

        emit(CashPaymentLoaded(response: response));
      } catch (e) {
        log("CashPaymentBloc Error: $e", name: "CashPaymentBloc");
        emit(CashPaymentError("Unable to load cash payments. Please try again."));
      } finally {
        isFetching = false;
      }
    });
  }
}
