import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin/data/repo/auth_repository.dart';
import 'total_active_event.dart';
import 'total_active_state.dart';

class TotalActiveBloc extends Bloc<TotalActiveEvent, TotalActiveState> {
  final TotalActiveSchemesRepository repository;

  TotalActiveBloc({required this.repository}) : super(TotalActiveInitial()) {
    //  Fetch all active schemes (no date filter)
    on<FetchTotalActiveSchemes>((event, emit) async {
      emit(TotalActiveLoading());
      try {
        final response = await repository.getTotalActiveSchemes();

        if (response.data.isEmpty) {
          emit(TotalActiveError(message: "No active schemes found."));
          return;
        }

        //  Show all active schemes (no filtering by date)
        emit(TotalActiveLoaded(
          response: response,
        ));
      } catch (e) {
        log("TotalActiveBloc Error: $e", name: "TotalActiveBloc");
        emit(TotalActiveError(
          message: "Unable to load active schemes. Please try again.",
        ));
      }
    });

    //  Add cash payment
    on<AddCashPayment>((event, emit) async {
      emit(CashPaymentLoading());
      try {
        final response = await repository.addCashCustomerSavings(
          savingId: event.savingId,
          amount: event.amount,
        );

        emit(CashPaymentSuccess(
          savingId: response['saving_id'],
          totalAmount: response['total_amount']?.toString() ?? "0",
        ));

        //  Refresh data after successful payment
        final updated = await repository.getTotalActiveSchemes();
        emit(TotalActiveLoaded(response: updated));
      } catch (e) {
        log("AddCashPayment Error: $e", name: "TotalActiveBloc");
        emit(CashPaymentFailure(message: e.toString()));
      }
    });
  }
}
