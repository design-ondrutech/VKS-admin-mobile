import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin/blocs/online_payment/online_payment_event.dart';
import 'package:admin/blocs/online_payment/online_payment_state.dart';
import 'package:admin/data/repo/auth_repository.dart';

class OnlinePaymentBloc extends Bloc<FetchOnlinePayments, OnlinePaymentState> {
  final OnlinePaymentRepository repository;
  bool isFetching = false;

  OnlinePaymentBloc(this.repository) : super(OnlinePaymentInitial()) {
    on<FetchOnlinePayments>((event, emit) async {
      if (isFetching) return; // Prevent multiple fetches at once
      isFetching = true;

      try {
        emit(OnlinePaymentLoading());

        final response = await repository.fetchOnlinePayments(
          page: event.page,
          limit: event.limit,
        );

        emit(OnlinePaymentLoaded(response: response));
      } catch (e) {
        log("OnlinePaymentBloc Error: $e", name: "OnlinePaymentBloc");

        final errorMessage = e.toString().contains("NaN")
            ? "Invalid gold gram value found in transactions. Please contact support."
            : "Unable to load online payments. Please try again.";

        emit(OnlinePaymentError(message: errorMessage));
      } finally {
        isFetching = false;
      }
    });
  }
}
