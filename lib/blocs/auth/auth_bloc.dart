import 'package:admin/data/graphql_config.dart';
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
        final data = await authRepository.adminLogin(
          event.context,
          event.phone,
          event.password,
        );

        if (data['accessToken'] != null) {
          final token = data['accessToken'];
          final userName = data['user']?['uName'] ?? '';
          final tenantUuid = data['user']?['tenant_uuid'] ?? '';

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('accessToken', token);
          await prefs.setString('tenantUuid', tenantUuid);

          // rebuild client so all future API calls have token header
          await getGraphQLClient();

          emit(AuthSuccess(token: token, name: userName));
        } else {
          emit(AuthFailure("Invalid phone or password"));
        }
      } catch (e) {
        print('❌ AuthBloc Login Error: $e');
        emit(AuthFailure("Login failed: ${e.toString()}"));
      }
    });
  }
}
