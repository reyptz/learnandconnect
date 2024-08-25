import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthSignIn extends AuthEvent {
  final String email;
  final String password;

  const AuthSignIn({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthSignUp extends AuthEvent {
  final String email;
  final String password;
  final String name;

  const AuthSignUp({required this.email, required this.password, required this.name});

  @override
  List<Object?> get props => [email, password, name];
}

class AuthSignOut extends AuthEvent {}
