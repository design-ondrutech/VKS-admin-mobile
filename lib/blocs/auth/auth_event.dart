abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String phone;
  final String password;

  LoginRequested(this.phone, this.password);
}
