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
        final response = await repository.fetchTodayActiveSchemes(
          startDate: event.startDate,
          savingId: event.savingId,
          page: 1, // Always fetch full list
          limit: 9999,
        );

        if (response.data.isEmpty) {
          emit(TodayActiveSchemeError("No active schemes found for today."));
          return;
        }

        final totalItems = response.data.length;
        final totalPages = (totalItems / event.limit).ceil();

        final startIndex = (event.page - 1) * event.limit;
        final endIndex =
            (startIndex + event.limit) > totalItems ? totalItems : (startIndex + event.limit);

        final paginatedData = response.data.sublist(startIndex, endIndex);

        final localResponse = response.copyWith(
          data: paginatedData,
          currentPage: event.page,
          totalPages: totalPages,
          limit: event.limit,
        );

        log("📄 Local Pagination → Showing page ${event.page} of $totalPages | Items ${startIndex + 1}–$endIndex",
            name: "TodayActiveSchemeBloc");

        emit(TodayActiveSchemeLoaded(
          response: localResponse,
          currentPage: event.page,
          totalPages: totalPages,
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
