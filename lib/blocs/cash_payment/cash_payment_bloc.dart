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
        final data = await repository.fetchCashPayments();
        emit(CashPaymentLoaded(data));
      } catch (e) {
        emit(CashPaymentError(e.toString()));
      }
    });
  }
}
