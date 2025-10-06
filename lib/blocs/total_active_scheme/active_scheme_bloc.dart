import 'dart:developer';
import 'package:admin/data/repo/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'active_scheme_event.dart';
import 'active_scheme_state.dart';

class TotalActiveBloc extends Bloc<TotalActiveEvent, TotalActiveState> {
  final TotalActiveSchemesRepository repository;

  TotalActiveBloc({required this.repository}) : super(TotalActiveInitial()) {
    //  Fetch all active schemes
    on<FetchTotalActiveSchemes>((event, emit) async {
      emit(TotalActiveLoading());
      try {
        final response = await repository.getTotalActiveSchemes();
        if (response.data.isEmpty) {
          emit(TotalActiveError(message: "No active schemes found."));
          return;
        }

        final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
        final todayData = response.data.where((scheme) {
          final startDate = DateFormat('yyyy-MM-dd')
              .format(DateTime.tryParse(scheme.startDate) ?? DateTime(1900));
          return startDate == today;
        }).toList();

        if (todayData.isEmpty) {
          emit(TotalActiveError(
              message: "No active schemes found for today."));
        } else {
          emit(
            TotalActiveLoaded(
              response: response.copyWith(
                data: todayData,
                totalCount: todayData.length,
              ),
            ),
          );
        }
      } catch (e) {
        log("TotalActiveBloc Error: $e", name: "TotalActiveBloc");
        emit(TotalActiveError(
          message: e.toString().contains("No active")
              ? "No active schemes found."
              : "Unable to load today active schemes. Please try again.",
        ));
      }
    });

    //  Add cash payment mutation
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

        // Optional: auto-refresh active schemes after success
        final updated = await repository.getTotalActiveSchemes();
        emit(TotalActiveLoaded(response: updated));
      } catch (e) {
        log("AddCashPayment Error: $e", name: "TotalActiveBloc");
        emit(CashPaymentFailure(message: e.toString()));
      }
    });
  }
}
