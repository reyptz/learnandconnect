import 'package:equatable/equatable.dart';
import '../../data/models/user_model.dart';  // Assurez-vous que l'énumération Role est importée

abstract class RoleEvent extends Equatable {
  const RoleEvent();

  @override
  List<Object> get props => [];
}

class LoadRoles extends RoleEvent {}

class AddRole extends RoleEvent {
  final Role role;

  const AddRole({required this.role});

  @override
  List<Object> get props => [role];
}

class UpdateRole extends RoleEvent {
  final Role oldRole;
  final Role newRole;

  const UpdateRole({required this.oldRole, required this.newRole});

  @override
  List<Object> get props => [oldRole, newRole];
}

class DeleteRole extends RoleEvent {
  final Role role;

  const DeleteRole({required this.role});

  @override
  List<Object> get props => [role];
}
