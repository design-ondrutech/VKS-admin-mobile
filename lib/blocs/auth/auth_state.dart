abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}


class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}
class AuthSuccess extends AuthState {
  final String token;
  final String name;
  AuthSuccess({required this.token, required this.name});
}
