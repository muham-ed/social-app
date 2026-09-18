import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class LoginRequested extends AuthEvent {
  final String emailOrUsername;
  final String password;
  const LoginRequested({required this.emailOrUsername, required this.password});
  @override
  List<Object?> get props => [emailOrUsername, password];
}

class RegisterRequested extends AuthEvent {
  final String name;
  final String username;
  final String email;
  final String password;
  const RegisterRequested({
    required this.name,
    required this.username,
    required this.email,
    required this.password,
  });
  @override
  List<Object?> get props => [name, username, email, password];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}