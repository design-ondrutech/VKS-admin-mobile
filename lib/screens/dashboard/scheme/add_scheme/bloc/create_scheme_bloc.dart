// import 'package:admin/data/repo/auth_repository.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'create_scheme_event.dart';
// import 'create_scheme_state.dart';

// class CreateSchemeBloc extends Bloc<CreateSchemeEvent, CreateSchemeState> {
//   final CreateSchemeRepository repository;

//   CreateSchemeBloc({required this.repository}) : super(CreateSchemeInitial()) {
//     on<SubmitCreateScheme>((event, emit) async {
//       emit(CreateSchemeLoading());
//       try {
//         final scheme = await repository.createScheme(event.model.toJson());
//         emit(CreateSchemeSuccess(scheme));
//       } catch (e) {
//         emit(CreateSchemeFailure(e.toString()));
//       }
//     });

//     on<SubmitUpdateScheme>((event, emit) async {
//       emit(CreateSchemeLoading());
//       try {
//         final response = await repository.updateScheme(
//           event.schemeId,
//           event.model.toJson(), // do NOT include scheme_id inside data
//         );
//         emit(CreateSchemeSuccess(response));
//       } catch (e) {
//         emit(CreateSchemeFailure(e.toString()));
//       }
//     });
//   }
// }

