import 'package:admin/data/repo/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final data = await authRepository.adminLogin(event.phone, event.password);

        if (data['accessToken'] != null) {
          final token = data['accessToken'];
          final userName = data['user']?['uName'] ?? '';
          final tenantUuid = data['user']?['tenant_uuid'] ?? '';

          //  Save access token and tenant UUID locally
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('accessToken', token);
          await prefs.setString('tenantUuid', tenantUuid);

          emit(AuthSuccess(token: token, name: userName));
        } else {
          emit(AuthFailure("Invalid phone number or password."));
        }
      } catch (e) {
        emit(AuthFailure("Something went wrong. Please try again later."));
      }
    });
  }
}
