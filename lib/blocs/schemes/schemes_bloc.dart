import 'package:admin/data/repo/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'schemes_event.dart';
import 'schemes_state.dart';

class SchemesBloc extends Bloc<SchemesEvent, SchemesState> {
  final SchemeRepository repository;

  SchemesBloc(this.repository) : super(SchemeInitial()) {
    // Fetch schemes
    on<FetchSchemes>((event, emit) async {
      emit(SchemeLoading());
      try {
        final schemes = await repository.fetchSchemes();
        emit(SchemeLoaded(schemes));
      } catch (e) {
        emit(SchemeError(e.toString()));
      }
    });

    // Create scheme
   on<AddScheme>((event, emit) async {
  emit(SchemeLoading());
  try {
    await repository.createScheme(event.scheme.toCreateInput());
    emit(SchemeActionSuccess("Scheme created successfully")); 
    final schemes = await repository.fetchSchemes();
    emit(SchemeLoaded(schemes));
  } catch (e) {
    emit(SchemeError(e.toString()));
  }
});

on<UpdateScheme>((event, emit) async {
  emit(SchemeLoading());
  try {
    await repository.updateScheme(
      event.scheme.schemeId,
      event.scheme.toUpdateInput(),
    );
    emit(SchemeActionSuccess("Scheme updated successfully")); //  new
    final schemes = await repository.fetchSchemes();
    emit(SchemeLoaded(schemes));
  } catch (e) {
    emit(SchemeError(e.toString()));
  }
});


    // Delete scheme
on<DeleteScheme>((event, emit) async {
  emit(SchemeLoading());
  try {
    final success = await repository.deleteScheme(event.schemeId);
    if (success) {
      emit(SchemeActionSuccess("Scheme deleted successfully"));
      final schemes = await repository.fetchSchemes();
      emit(SchemeLoaded(schemes));
    } else {
      emit(SchemeError("Failed to delete scheme"));
    }
  } catch (e) {
    emit(SchemeError(e.toString()));
  }
});




  }
}
