import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/role_service.dart';
import 'role_event.dart';
import 'role_state.dart';

class RoleBloc extends Bloc<RoleEvent, RoleState> {
  final RoleService _roleService;

  RoleBloc(this._roleService) : super(RoleInitial());

  @override
  Stream<RoleState> mapEventToState(RoleEvent event) async* {
    if (event is LoadRoles) {
      yield RoleLoading();
      try {
        final roles = await _roleService.getRoles();
        yield RoleLoaded(roles: roles);
      } catch (e) {
        yield RoleError(message: e.toString());
      }
    } else if (event is AddRole) {
      try {
        await _roleService.addRole(event.role);
        add(LoadRoles());  // Recharge les rôles après ajout
      } catch (e) {
        yield RoleError(message: e.toString());
      }
    } else if (event is UpdateRole) {
      try {
        await _roleService.updateRole(event.oldRole, event.newRole);
        add(LoadRoles());  // Recharge les rôles après mise à jour
      } catch (e) {
        yield RoleError(message: e.toString());
      }
    } else if (event is DeleteRole) {
      try {
        await _roleService.deleteRole(event.role);
        add(LoadRoles());  // Recharge les rôles après suppression
      } catch (e) {
        yield RoleError(message: e.toString());
      }
    }
  }
}
