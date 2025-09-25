// import 'package:admin/data/repo/auth_repository.dart';
// import 'package:admin/screens/dashboard/scheme/add_scheme/bloc/update_bloc/UpdateScheme_Event%20.dart';
// import 'package:admin/screens/dashboard/scheme/add_scheme/bloc/update_bloc/UpdateScheme_State%20.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class UpdateSchemeBloc extends Bloc<UpdateSchemeEvent, UpdateSchemeState> {
//   final UpdateSchemeRepository repository;

//   UpdateSchemeBloc(this.repository) : super(const UpdateSchemeState()) {
//     on<SubmitUpdateScheme>((event, emit) async {
//       emit(state.copyWith(isLoading: true, error: null, updatedScheme: null));

//       try {
//         final scheme = await repository.updateScheme(event.schemeId, event.model);
//         emit(state.copyWith(isLoading: false, updatedScheme: scheme));
//       } catch (e) {
//         emit(state.copyWith(isLoading: false, error: e.toString()));
//       }
//     });
//   }
// }
