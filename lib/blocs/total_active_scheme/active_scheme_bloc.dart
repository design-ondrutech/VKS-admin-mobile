import 'dart:developer';
import 'package:admin/data/repo/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'active_scheme_event.dart';
import 'active_scheme_state.dart';

class TotalActiveBloc extends Bloc<TotalActiveEvent, TotalActiveState> {
  final TotalActiveSchemesRepository repository;

  TotalActiveBloc({required this.repository}) : super(TotalActiveInitial()) {
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
          emit(TotalActiveError(message: "No active schemes found for today."));
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
        // Developer log (console-only)
        log("TotalActiveBloc Error: $e", name: "TotalActiveBloc");

        // User-friendly error message
        emit(TotalActiveError(
          message: e.toString().contains("No active")
              ? "No active schemes found."
              : "Unable to load total active schemes. Please try again.",
        ));
      }
    });
  }
}
