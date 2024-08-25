import 'package:equatable/equatable.dart';
import '../../data/models/user_model.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class LoadUsers extends UserEvent {}

class AddUser extends UserEvent {
  final User user;

  const AddUser({required this.user});

  @override
  List<Object> get props => [user];
}

class UpdateUser extends UserEvent {
  final User user;

  const UpdateUser({required this.user});

  @override
  List<Object> get props => [user];
}

class DeleteUser extends UserEvent {
  final String userId;

  const DeleteUser({required this.userId});

  @override
  List<Object> get props => [userId];
}
