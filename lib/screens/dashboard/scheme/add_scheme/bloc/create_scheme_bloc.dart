import 'package:admin/data/repo/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'create_scheme_event.dart';
import 'create_scheme_state.dart';

class CreateSchemeBloc extends Bloc<CreateSchemeEvent, CreateSchemeState> {
  final CreateSchemeRepository repository;

  CreateSchemeBloc(this.repository) : super(const CreateSchemeState()) {
    on<SubmitCreateScheme>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: null));
      try {
        final scheme = await repository.createScheme(event.data);
        emit(state.copyWith(isLoading: false, createdScheme: scheme, error: null));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: e.toString()));
      }
    });
  }
}
