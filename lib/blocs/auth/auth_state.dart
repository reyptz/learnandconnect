import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final firebase_auth.User user;
  final Object? userData;

  const AuthSuccess({required this.user, this.userData});

  @override
  List<Object?> get props => [user, userData];
}

class PasswordResetSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

// State for redirecting to the Dashboard
class AuthRedirectToDashboard extends AuthState {
  final firebase_auth.User user;

  const AuthRedirectToDashboard({required this.user});

  @override
  List<Object?> get props => [user];
}

// State for redirecting to the Home screen
class AuthRedirectToHome extends AuthState {
  final firebase_auth.User user;

  const AuthRedirectToHome({required this.user});

  @override
  List<Object?> get props => [user];
}
