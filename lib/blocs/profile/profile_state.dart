import 'package:equatable/equatable.dart';
import '../../data/models/user_model.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final User user;

  ProfileLoaded({required this.user});

  @override
  List<Object> get props => [user];
}

class ProfileError extends ProfileState {
  final String error;

  ProfileError({required this.error});

  @override
  List<Object> get props => [error];
}
