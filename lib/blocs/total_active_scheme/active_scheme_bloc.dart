// active_scheme_bloc.dart
import 'package:admin/blocs/total_active_scheme/active_scheme_event.dart';
import 'package:admin/blocs/total_active_scheme/active_scheme_state.dart';
import 'package:admin/data/repo/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TotalActiveBloc extends Bloc<TotalActiveEvent, TotalActiveState> {
  final TotalActiveSchemesRepository repository;

  TotalActiveBloc({required this.repository}) : super(TotalActiveInitial()) {
    on<FetchTotalActiveSchemes>((event, emit) async {
      emit(TotalActiveLoading());
      try {
        final response = await repository.getTotalActiveSchemes();
        emit(TotalActiveLoaded(response: response));
      } catch (e) {
        emit(TotalActiveError(message: e.toString()));
      }
    });
  }
}

