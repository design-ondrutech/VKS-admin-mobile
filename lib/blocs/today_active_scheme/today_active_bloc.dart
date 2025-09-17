import 'package:admin/blocs/today_active_scheme/today_active_event.dart';
import 'package:admin/blocs/today_active_scheme/today_active_state.dart';
import 'package:admin/data/repo/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodayActiveSchemeBloc extends Bloc<TodayActiveSchemeEvent, TodayActiveSchemeState> {
  final TodayActiveSchemeRepository repository;

  TodayActiveSchemeBloc(this.repository) : super(TodayActiveSchemeInitial()) {
    on<FetchTodayActiveSchemes>((event, emit) async {
      emit(TodayActiveSchemeLoading());
      try {
        final response = await repository.fetchTodayActiveSchemes(event.startDate);
        emit(TodayActiveSchemeLoaded(response));
      } catch (e) {
        emit(TodayActiveSchemeError(e.toString()));
      }
    });
  }
}
