import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin/data/repo/auth_repository.dart';
import 'today_active_event.dart';
import 'today_active_state.dart';

class TodayActiveSchemeBloc
    extends Bloc<TodayActiveSchemeEvent, TodayActiveSchemeState> {
  final TodayActiveSchemeRepository repository;

  TodayActiveSchemeBloc({required this.repository})
      : super(TodayActiveSchemeInitial()) {
    ///  Fetch today’s active schemes (with fresh backend data)
    on<FetchTodayActiveSchemes>((event, emit) async {
      emit(TodayActiveSchemeLoading());
      try {
        //  Force fresh data from repository (networkOnly)
        final response = await repository.fetchTodayActiveSchemes(
          startDate: event.startDate,
          savingId: event.savingId,
          page: event.page,
          limit: event.limit,
        );

        //  Filter: only today's active schemes
        final today = DateTime.now();
        final filteredSchemes = response.data.where((scheme) {
          final isActive = scheme.status.toLowerCase() == "active";
          final schemeDate = DateTime.tryParse(scheme.startDate);
          final isToday = schemeDate != null &&
              schemeDate.year == today.year &&
              schemeDate.month == today.month &&
              schemeDate.day == today.day;
          return isActive && isToday;
        }).toList();

        if (filteredSchemes.isEmpty) {
          emit(TodayActiveSchemeError("No active schemes for today found."));
          return;
        }

        //  Client-side pagination
        final startIndex = (event.page - 1) * event.limit;
        final endIndex =
            (startIndex + event.limit).clamp(0, filteredSchemes.length);
        final pageData = filteredSchemes.sublist(startIndex, endIndex);

        final totalPages = (filteredSchemes.length / event.limit).ceil();

        //  Ensure new data instance for rebuild
        final paginatedResponse = response.copyWith(
          data: List.from(pageData),
          totalCount: filteredSchemes.length,
          page: event.page,
          limit: event.limit,
        );

        emit(TodayActiveSchemeLoaded(
          paginatedResponse,
          currentPage: event.page,
          totalPages: totalPages,
        ));
      } catch (e, s) {
        log("Bloc Error (Fetch Today Active): $e\n$s",
            name: "TodayActiveSchemeBloc");
        emit(TodayActiveSchemeError("Failed to load active schemes"));
      }
    });

    /// 🔹 Add Cash Payment (Mutation)
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

        // ⚡ Wait a bit for backend to update before refetch
        await Future.delayed(const Duration(milliseconds: 400));

        //  Auto-refresh today’s active schemes (fresh fetch)
        final today = DateTime.now().toIso8601String().split('T').first;
        add(FetchTodayActiveSchemes(
          startDate: today,
          page: 1,
          limit: 10,
        ));
      } catch (e, s) {
        log("Bloc Error (Add Cash): $e\n$s",
            name: "TodayActiveSchemeBloc");
        emit(AddCashSavingError("Unable to add payment. Please try again."));
      }
    });
  }
}
