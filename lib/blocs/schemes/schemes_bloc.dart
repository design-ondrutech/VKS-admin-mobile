import 'package:admin/data/repo/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'schemes_event.dart';
import 'schemes_state.dart';

class SchemesBloc extends Bloc<SchemesEvent, SchemesState> {
  final SchemeRepository repository;

  SchemesBloc(this.repository) : super(const SchemesState()) {
    // Fetch API Data
    on<FetchSchemes>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: ""));
      try {
        final response = await repository.fetchSchemes(); //  SchemesResponse
        emit(state.copyWith(
          schemes: response.data, //  extract only List<Scheme>
          totalCount: response.totalCount, //  add total count
          currentPage: response.currentPage,
          totalPages: response.totalPages,
          isLoading: false,
          error: "",
        ));
      } catch (e) {
        emit(state.copyWith(
          isLoading: false,
          error: e.toString(),
        ));
      }
    });

    // Open Popup
    on<OpenAddSchemePopup>((event, emit) {
      emit(state.copyWith(isPopupOpen: true));
    });

    // Close Popup
    on<CloseAddSchemePopup>((event, emit) {
      emit(state.copyWith(isPopupOpen: false));
    });

    // Submit Scheme (dummy for now)
    on<SubmitScheme>((event, emit) async {
      emit(state.copyWith(isSubmitting: true));
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(isSubmitting: false, isPopupOpen: false));
    });
  }
}
