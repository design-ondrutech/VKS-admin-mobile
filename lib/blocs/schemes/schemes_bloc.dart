import 'package:admin/data/repo/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'schemes_event.dart';
import 'schemes_state.dart';

class SchemesBloc extends Bloc<SchemesEvent, SchemesState> {
  final SchemeRepository repository;

  SchemesBloc(this.repository) : super(SchemeInitial()) {
    on<FetchSchemes>((event, emit) async {
      emit(SchemeLoading());
      try {
        final schemes = await repository.getAllSchemes();
        emit(SchemeLoaded(schemes));
      } catch (e) {
        emit(SchemeError(e.toString()));
      }
    });

   on<AddScheme>((event, emit) {
  if (state is SchemeLoaded) {
    final current = (state as SchemeLoaded).schemes;
    final newList = [...current, event.scheme];
    emit(SchemeLoaded(newList)); // UI refresh
    emit(SchemeOperationSuccess(event.scheme)); // optional success message
  }
});
on<UpdateScheme>((event, emit) async {
  if (state is SchemeLoaded) {
    try {
      //  Call API (Repository)
      final updatedScheme = await repository.updateScheme(event.scheme);

      //  Update state list
      final currentList = (state as SchemeLoaded).schemes;
      final updatedList = currentList.map((s) {
        if (s.schemeId == updatedScheme.schemeId) return updatedScheme;
        return s;
      }).toList();

      //  Emit updated list and success state
      emit(SchemeLoaded(updatedList));
      emit(SchemeOperationSuccess(updatedScheme));
    } catch (e) {
      emit(SchemeError("Failed to update scheme: $e"));
    }
  }
});



  }
}
