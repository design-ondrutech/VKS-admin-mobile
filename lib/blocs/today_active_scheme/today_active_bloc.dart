import 'dart:developer';
import 'package:admin/data/repo/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'today_active_event.dart';
import 'today_active_state.dart';

class TodayActiveSchemeBloc
    extends Bloc<TodayActiveSchemeEvent, TodayActiveSchemeState> {
  final TodayActiveSchemeRepository repository;

  TodayActiveSchemeBloc({required this.repository})
      : super(TodayActiveSchemeInitial()) {
    on<FetchTodayActiveSchemes>((event, emit) async {
      emit(TodayActiveSchemeLoading());
      try {
        // Call repository to fetch backend paginated data
        final response = await repository.fetchTodayActiveSchemes(
          startDate: event.startDate,
          savingId: event.savingId,
          page: event.page,
          limit: event.limit,
        );

        //  If no schemes found
        if (response.data.isEmpty) {
          emit(TodayActiveSchemeError("No active schemes found for today."));
          return;
        }

      
        emit(TodayActiveSchemeLoaded(
          response: response,
          currentPage: response.currentPage,
          totalPages: response.totalPages,
        ));
      } catch (e, s) {
        log("❌ Error while fetching today active schemes: $e\n$s",
            name: "TodayActiveSchemeBloc");
        emit(TodayActiveSchemeError("Failed to load today’s active schemes."));
      }
    });

    on<AddCashCustomerSavingEvent>((event, emit) async {
      emit(AddCashSavingLoading());
      try {
        final result = await repository.addCashCustomerSavings(
          savingId: event.savingId,
          amount: event.amount,
        );

        log("✅ Payment Added Successfully: $result",
            name: "TodayActiveSchemeBloc");

        emit(AddCashSavingSuccess(result));

        await Future.delayed(const Duration(milliseconds: 500));

        final today = DateTime.now().toIso8601String().split('T').first;
        add(FetchTodayActiveSchemes(
          startDate: today,
          page: 1,
          limit: 10,
        ));
      } catch (e, s) {
        log("❌ Error while adding cash payment: $e\n$s",
            name: "TodayActiveSchemeBloc");
        emit(AddCashSavingError("Unable to add payment. Please try again."));
      }
    });
  }
}
