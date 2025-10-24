// auth_event.dart
import 'package:flutter/material.dart';

abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String phone;
  final String password;
  final BuildContext context; // ded

  LoginRequested(this.phone, this.password, this.context);
}
