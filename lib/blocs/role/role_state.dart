import 'package:equatable/equatable.dart';
import '../../data/models/user_model.dart';

abstract class RoleState extends Equatable {
  const RoleState();

  @override
  List<Object> get props => [];
}

class RoleInitial extends RoleState {}

class RoleLoading extends RoleState {}

class RoleLoaded extends RoleState {
  final List<Role> roles;

  const RoleLoaded({required this.roles});

  @override
  List<Object> get props => [roles];
}

class RoleError extends RoleState {
  final String message;

  const RoleError({required this.message});

  @override
  List<Object> get props => [message];
}
