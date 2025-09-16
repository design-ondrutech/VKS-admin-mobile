import 'package:admin/data/repo/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final data =
            await authRepository.adminLogin(event.phone, event.password);

        ///  Check if API returned success or error
        if (data['accessToken'] != null) {
          emit(AuthSuccess(
            token: data['accessToken'],
            name: data['user']?['uName'] ?? '',
          ));
        } else {
          /// If no token returned → treat as invalid credentials
          emit(AuthFailure("Invalid phone or password"));
        }
      } catch (e) {
        /// Catch network errors or unexpected issues
        emit(AuthFailure("Something went wrong. Please try again."));
      }
    });
  }
}
