import 'package:admin/data/repo/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'create_scheme_event.dart';
import 'create_scheme_state.dart';

class CreateSchemeBloc extends Bloc<CreateSchemeEvent, CreateSchemeState> {
  final CreateSchemeRepository repository;

  CreateSchemeBloc(this.repository) : super(const CreateSchemeState()) {
    /// CREATE scheme event
    on<SubmitCreateScheme>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: null, createdScheme: null));

      try {
        final scheme = await repository.createScheme(event.data);

        emit(state.copyWith(
          isLoading: false,
          createdScheme: scheme,
          isUpdated: false,
          error: null,
        ));

        // Reset state after short delay (to avoid duplicate snackbar)
        await Future.delayed(const Duration(milliseconds: 200));
        emit(state.copyWith(createdScheme: null));

      } catch (e) {
        emit(state.copyWith(isLoading: false, error: e.toString()));
      }
    });

    /// UPDATE scheme event
    on<SubmitUpdateScheme>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: null, createdScheme: null));

      try {
        //  Make sure to pass event.schemeId correctly
        final scheme = await repository.updateScheme(event.schemeId, event.data);

        emit(state.copyWith(
          isLoading: false,
          createdScheme: scheme,
          isUpdated: true,
          error: null,
        ));

        await Future.delayed(const Duration(milliseconds: 200));
        emit(state.copyWith(createdScheme: null));

      } catch (e) {
        emit(state.copyWith(isLoading: false, error: e.toString()));
      }
    });
  }
}
