import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin/data/repo/auth_repository.dart';
import 'total_active_event.dart';
import 'total_active_state.dart';

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

        emit(TotalActiveLoaded(response: response));
      } catch (e) {
        log("TotalActiveBloc Error: $e", name: "TotalActiveBloc");
        emit(TotalActiveError(
          message: "Unable to load active schemes. Please try again.",
        ));
      }
    });

    //  Add Cash Payment
    on<AddCashPayment>((event, emit) async {
      emit(CashPaymentLoading(savingId: event.savingId));
      try {
        final response = await repository.addCashCustomerSavings(
          savingId: event.savingId,
          amount: event.amount,
        );

        log("💰 Payment success: $response", name: "TotalActiveBloc");
        await Future.delayed(const Duration(seconds: 1));

        emit(CashPaymentSuccess(
          savingId: response['saving_id'],
          totalAmount: response['total_amount']?.toString() ?? "0",
        ));

        await Future.delayed(const Duration(milliseconds: 400));

        final updated = await repository.getTotalActiveSchemes();
        emit(TotalActiveLoaded(response: updated));
      } catch (e, s) {
        log("❌ AddCashPayment Error: $e\n$s", name: "TotalActiveBloc");
        emit(CashPaymentFailure(message: e.toString()));
      }
    });

    //  Update Gold Delivered (Partial / Full)
    // on<UpdateGoldDelivered>((event, emit) async {
    //   emit(GoldDeliveryLoading());
    //   try {
    //     final response = await repository.updateDeliveredGold(
    //       savingId: event.savingId,
    //       deliveredGoldWeight: event.deliveredGoldWeight,
    //       isFullyDelivered: event.isFullyDelivered,
    //     );

    //     final data = response['updatedScheme'] ?? {};
    //     final message =
    //         response['message'] ?? "Gold delivery updated successfully.";

    //     emit(GoldDeliverySuccess(
    //       savingId: event.savingId,
    //       deliveredWeight:
    //           (data['delivered_gold_weight'] as num?)?.toDouble() ?? 0.0,
    //       isFullyDelivered: event.isFullyDelivered,
    //       message: message,
    //     ));

    //     // Refresh scheme list after update
    //     final updated = await repository.getTotalActiveSchemes();
    //     emit(TotalActiveLoaded(response: updated));
    //   } catch (e, s) {
    //     log("❌ Gold Delivery Error: $e\n$s", name: "TotalActiveBloc");
    //     emit(GoldDeliveryFailure(error: e.toString()));
    //   }
    // });
  }
}
