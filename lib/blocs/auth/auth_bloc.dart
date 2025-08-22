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
        final data = await authRepository.adminLogin(event.phone, event.password);

        emit(AuthSuccess(
          token: data['accessToken'],
          name: data['user']['uName'],
        ));
      } catch (e) {
        emit(AuthFailure("Login Failed: ${e.toString()}"));
      }
    });
  }
}
