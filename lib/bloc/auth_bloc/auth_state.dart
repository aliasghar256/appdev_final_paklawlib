import '../../models/user_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoggedIn extends AuthState {
  final User user;

  AuthLoggedIn({required this.user});
}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});
}