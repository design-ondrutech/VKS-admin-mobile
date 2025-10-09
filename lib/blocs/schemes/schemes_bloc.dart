import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin/data/repo/auth_repository.dart';
import 'schemes_event.dart';
import 'schemes_state.dart';

class SchemesBloc extends Bloc<SchemesEvent, SchemesState> {
  final SchemeRepository repository;

  SchemesBloc(this.repository) : super(SchemeInitial()) {
    //  Fetch all schemes
    on<FetchSchemes>((event, emit) async {
      emit(SchemeLoading());
      try {
        final schemes = await repository.fetchSchemes();
        emit(SchemeLoaded(schemes));
      } catch (e) {
        emit(SchemeError(e.toString()));
      }
    });

    //  Add scheme
    on<AddScheme>((event, emit) async {
      emit(SchemeLoading());
      try {
        await repository.createScheme(event.scheme.toCreateInput());
        emit(SchemeActionSuccess("Scheme created successfully"));
        //  Auto refresh after create
        final schemes = await repository.fetchSchemes();
        emit(SchemeLoaded(schemes));
      } catch (e) {
        emit(SchemeError(e.toString()));
      }
    });

    //  Update scheme
    on<UpdateScheme>((event, emit) async {
      emit(SchemeLoading());
      try {
        await repository.updateScheme(
          event.scheme.schemeId,
          event.scheme.toUpdateInput(),
        );
        emit(SchemeActionSuccess("Scheme updated successfully"));
        //  Auto refresh after update
        final schemes = await repository.fetchSchemes();
        emit(SchemeLoaded(schemes));
      } catch (e) {
        emit(SchemeError(e.toString()));
      }
    });

    //  Delete scheme
    on<DeleteScheme>((event, emit) async {
      emit(SchemeLoading());
      try {
        final success = await repository.deleteScheme(event.schemeId);
        if (success) {
          emit(SchemeActionSuccess("Scheme deleted successfully"));
          //  Auto refresh after delete
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
