import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin/data/repo/auth_repository.dart';
import 'total_active_event.dart';
import 'total_active_state.dart';

class TotalActiveBloc extends Bloc<TotalActiveEvent, TotalActiveState> {
  final TotalActiveSchemesRepository repository;
  int currentPage = 1;
  int totalPages = 1;
  final int limit = 10; // Default limit
  bool isFetching = false;

  TotalActiveBloc({required this.repository}) : super(TotalActiveInitial()) {
    // Fetch all active schemes
    on<FetchTotalActiveSchemes>((event, emit) async {
      if (isFetching) return;
      isFetching = true;

      try {
        emit(TotalActiveLoading());

        final response = await repository.getTotalActiveSchemes(
          page: 1,
          limit: 10,
        );

        // Save pagination data (if available)
        currentPage = response.page;
        totalPages = (response.totalCount / response.limit).ceil();

        if (response.data.isEmpty) {
          emit(TotalActiveEmpty());
          return;
        }

        emit(TotalActiveLoaded(response: response));
      } catch (e) {
        log("TotalActiveBloc Error: $e", name: "TotalActiveBloc");
        emit(
          TotalActiveError(
            message: "Unable to load total active schemes. Please try again.",
          ),
        );
      } finally {
        isFetching = false;
      }
    });

    // Add Cash Payment
    on<AddCashPayment>((event, emit) async {
      emit(CashPaymentLoading(savingId: event.savingId));
      try {
        final response = await repository.addCashCustomerSavings(
          savingId: event.savingId,
          amount: event.amount,
        );

        log("💰 Payment success: $response", name: "TotalActiveBloc");
        await Future.delayed(const Duration(seconds: 1));

        emit(
          CashPaymentSuccess(
            savingId: response['saving_id'],
            totalAmount: response['total_amount']?.toString() ?? "0",
          ),
        );

        await Future.delayed(const Duration(milliseconds: 400));

        final updated = await repository.getTotalActiveSchemes(
          page: 1,
          limit: 10,
        );
        emit(TotalActiveLoaded(response: updated));
      } catch (e, s) {
        log("❌ AddCashPayment Error: $e\n$s", name: "TotalActiveBloc");
        emit(CashPaymentFailure(message: e.toString()));
      }
    });

    // Update Delivered Gold
    on<UpdateDeliveredGoldEvent>((event, emit) async {
      try {
        final success = await repository.updateDeliveredGold(
          savingId: event.savingId,
          deliveredGold: event.deliveredGold,
        );
        if (success) {
          add(FetchTotalActiveSchemes(page: currentPage, limit: limit));
        }
      } catch (e) {
        log("Error updating gold: $e");
      }
    });
  }
}
