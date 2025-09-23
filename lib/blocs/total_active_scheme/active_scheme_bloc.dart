import 'package:admin/blocs/total_active_scheme/active_scheme_event.dart';
import 'package:admin/blocs/total_active_scheme/active_scheme_state.dart';
import 'package:admin/data/repo/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TotalActiveSchemesBloc
    extends Bloc<TotalActiveSchemesEvent, TotalActiveSchemesState> {
  final TotalActiveSchemesRepository repository;

  TotalActiveSchemesBloc(this.repository)
      : super(TotalActiveSchemesInitial()) {
    on<FetchTotalActiveSchemes>((event, emit) async {
      emit(TotalActiveSchemesLoading());
      try {
        final response = await repository.fetchTotalActiveSchemes();
        emit(TotalActiveSchemesLoaded(response));
      } catch (e) {
        emit(TotalActiveSchemesError(e.toString()));
      }
    });
  }
}
