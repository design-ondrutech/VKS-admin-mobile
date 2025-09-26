import 'dart:developer';
import 'package:admin/data/repo/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'today_active_event.dart';
import 'today_active_state.dart';

class TodayActiveSchemeBloc extends Bloc<TodayActiveSchemeEvent, TodayActiveSchemeState> {
  final TodayActiveSchemeRepository repository;

  TodayActiveSchemeBloc({required this.repository}) : super(TodayActiveSchemeInitial()) {
    on<FetchTodayActiveSchemes>((event, emit) async {
      emit(TodayActiveSchemeLoading());
      try {
        final response = await repository.fetchTodayActiveSchemes(
          startDate: event.startDate,
          savingId: event.savingId,
        );

        if (response.data.isEmpty) {
          emit(TodayActiveSchemeError("No active schemes found."));
        } else {
          emit(TodayActiveSchemeLoaded(response));
        }
      } catch (e) {
        log("Bloc Error: $e", name: "TodayActiveSchemeBloc");
        emit(TodayActiveSchemeError(
          e.toString().contains("No active") ? "No active schemes found." : "Unable to load today's active schemes. Please try again.",
        ));
      }
    });
  }
}
