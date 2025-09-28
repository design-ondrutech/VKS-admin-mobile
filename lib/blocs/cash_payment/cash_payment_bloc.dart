import 'package:admin/blocs/cash_payment/cash_payment_event.dart';
import 'package:admin/blocs/cash_payment/cash_payment_state.dart';
import 'package:admin/data/repo/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CashPaymentBloc extends Bloc<CashPaymentEvent, CashPaymentState> {
  final CashPaymentRepository repository;

  CashPaymentBloc(this.repository) : super(CashPaymentInitial()) {
    on<FetchCashPayments>((event, emit) async {
      emit(CashPaymentLoading());
      try {
        final response = await repository.fetchCashPayments();

        // NaN-safe data
        final sanitizedData = response.data.map((payment) {
          return payment.copyWith(
            transactionGoldGram: payment.transactionGoldGram.isNaN
                ? 0.0
                : payment.transactionGoldGram,
          );
        }).toList();

        emit(CashPaymentLoaded(sanitizedData));
      } catch (e) {
        emit(CashPaymentError("Unable to load data. Please try again."));
      }
    });
  }
}
